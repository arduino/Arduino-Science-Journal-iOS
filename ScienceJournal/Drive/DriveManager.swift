//  
//  DriveManager.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 08/01/21.
//  Copyright © 2021 Arduino. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation
import GoogleAPIClientForREST
import RxSwift

extension DriveManager {
  class Folder: Equatable {
    let id: String
    let name: String
    let parent: Folder?

    init?(file: GTLRDrive_File, parent: Folder?) {
      guard let id = file.identifier,
            let name = file.name else {
        return nil
      }

      self.id = id
      self.name = name
      self.parent = parent
    }
    
    static func == (lhs: DriveManager.Folder, rhs: DriveManager.Folder) -> Bool {
      lhs.id == rhs.id
    }
  }
}

class DriveManager {
  let service: GTLRDriveService

  init(service: GTLRDriveService) {
    self.service = service
  }

  func subfolders(in folder: Folder? = nil) -> Observable<[Folder]> {
    let q: String
    if let parentFolder = folder {
      q = "mimeType = 'application/vnd.google-apps.folder' and trashed = false and '\(parentFolder.id)' in parents"
    } else {
      q = "mimeType = 'application/vnd.google-apps.folder' and trashed = false and 'root' in parents"
    }

    let query = GTLRDriveQuery_FilesList.query()
    query.pageSize = 100
    query.orderBy = "name"
    query.q = q
    query.fields = "files(id,name,parents),nextPageToken"

    let service = self.service

    return Observable.create { observer in
      let ticket = service.executeQuery(query, completionHandler: { _, files, error in
        if let error = error {
          observer.onError(error)
          return
        }

        defer { observer.onCompleted() }

        guard let filesList = files as? GTLRDrive_FileList,
              let files = filesList.files else {
          return
        }

        let subfolders = files.compactMap {
          Folder(file: $0, parent: folder)
        }

        observer.onNext(subfolders)
      })

      return Disposables.create(with: ticket.cancel)
    }
  }

  func createFolder(named folderName: String, in parentFolder: Folder?) -> Observable<Folder> {
    let file = GTLRDrive_File()
    file.name = folderName
    file.mimeType = "application/vnd.google-apps.folder"

    if let parentFolder = parentFolder {
      file.parents = [parentFolder.id]
    }

    let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: nil)
    query.fields = "id,name"
    
    let service = self.service

    return Observable.create { observer in
      let ticket = service.executeQuery(query, completionHandler: { _, file, error in
        if let error = error {
          observer.onError(error)
          return
        }
        
        defer { observer.onCompleted() }

        guard let file = file as? GTLRDrive_File,
              let folder = Folder(file: file, parent: parentFolder) else {
          return
        }

        observer.onNext(folder)
      })

      return Disposables.create(with: ticket.cancel)
    }
  }
}
