/*
 *  Copyright 2019 Google LLC. All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import Foundation

/// String constants for common Drive file names.
public struct Constants {

  public struct ArduinoSignIn {
    public static let host = "login.oniudra.cc"
    public static let apiHost = "api-dev.arduino.cc"
    public static let clientId = "y7mbB8KDw20S4XfXRAKRLgfYT9ao0IPx"
    public static let redirectUri = "arduino.sj://login.arduino.cc/ios/cc.arduino.sciencejournal/callback"
    
    public static let termsOfServiceUrl = URL(string: "https://www.arduino.cc/en/terms-conditions/?embed")!
    public static let privacyPolicyUrl = URL(string: "https://www.arduino.cc/en/privacy-policy/?embed")!
  }
  
  public struct ArduinoURLs {
    public static let activities = URL(string: String.navigationActivitiesLink)!
    public static let help = URL(string: String.navigationGetHelpLink)!
    public static let scienceKit = URL(string: String.navigationGetScienceKitLink)!
  }
  
  public struct GoogleSignInScopes {
    public static let drive = [
      "https://www.googleapis.com/auth/drive.appdata",
      "https://www.googleapis.com/auth/drive"
    ]
  }
  
  public struct Drive {
    public static let appDataFolderName = "appDataFolder"
    public static let defaultFileMetadataItemsFields =
        "items/fileSize,items/id,items/labels/trashed,items/title,items/version"
    public static let defaultFileMetadataFields =
        "fileSize,id,labels/trashed,packageId,title,version"
    public static let driveSpaceName = "drive"
    public static let experimentLibraryProtoFilename = "experiment_library.proto"
    public static let experimentProtoFilename = "experiment.proto"
    public static let folderMimeType = "application/vnd.google-apps.folder"
    public static let imageMimeType = "image/jpeg"
    public static let protoMimeType = "application/sj"
    public static let scienceJournalFolderName = "Science Journal"
    public static let versionProtoFilename = "version.proto"
  }

}
