<h3 align="center">
  <img src="https://content.arduino.cc/assets/SJ_Banner_Github2.png" alt="Science Journal Logo" width="700">
</h3>

[![Twitter: @Arduino](https://img.shields.io/badge/Contact-%40Arduino-orange)](https://twitter.com/arduino)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

[Arduino Science Journal for iOS][appstore] allows you to gather data from the world around you. It uses sensors to
measure your environment, like light and sound, so you can graph your data, record your experiments,
and organize your questions and ideas. It's the lab notebook you always have with you.

![Arduino Science Journal](https://content.arduino.cc/assets/SJ-screen_mockup_Blogpost%20-%20Main%20Pic.png)

## Features

* 📈 Visualize and graph data from a variety of sources including your device's built-in sensor
* 📲 Connect to external sensors over BLE .
* 📷 Annotate with pictures and 📝 notes.

## More

Science Journal formerly brought to you by Making & Science, an initiative by Google. Arduino Science Journal is now an official [Arduino Education](https://www.arduino.cc/education) product.

---

## Required dependencies
First, you'll need a Mac. We don't support building the iOS app on anything else.

Second, you'll need the latest version of [Xcode](https://developer.apple.com/xcode/) installed.

Third, we use a few open source frameworks to build this app, so you'll need to install [CocoaPods](https://cocoapods.org/) as your package manager in order to get what you need to build.

Fourth, we use [protobuf](https://developers.google.com/protocol-buffers/). You'll need to install that too. We use [Homebrew](https://brew.sh/) to install it.

Here are the steps to set up your environment:

1. Install Xcode.
2. Install CocoaPods by running `sudo gem install cocoapods` from your terminal.
3. Install Homebrew by following the instructions on the [Homebrew website](https://brew.sh/).
4. Install protobuf by running `brew install protobuf@3.6; brew link protobuf@3.6 -f` from your terminal.

## Building and running
Before you jump into coding, you'll need to run `pod install` from the root of this project (the folder that contains has the `Podfile` file)

Then you can open `ScienceJournal.xcworkspace`

**Note:** there is a `ScienceJournal.xcodeproj` file, but since we use CocoaPods, you shouldn't use that project file. If you do, nothing will work 😭

[appstore]: https://apps.apple.com/us/app/arduino-science-journal/id1518014927?mt=8
[ms]: https://science-journal.arduino.cc

## Contribute to Science Journal iOS

Check out [CONTRIBUTING.md](https://github.com/arduino/Arduino/blob/master/CONTRIBUTING.md) for more information on how to help with Science Journal iOS.

## Code of Conduct

Help us keep _Science Journal_ open and inclusive. Please read and follow our [Code of Conduct](https://github.com/arduino/Arduino-Science-Journal-iOS/blob/main/CODE_OF_CONDUCT.md).

## License

This project is licensed under the terms of the Apache 2.0 license. See the [LICENSE](https://github.com/arduino/Arduino-Science-Journal-iOS/blob/main/LICENSE) file.


## Security

If you think you found a vulnerability or other security-related bug in the Arduino Science Journal, please read our [security policy](https://www.arduino.cc/en/Main/Security) and report the bug to our Security Team 🛡️ Thank you!

e-mail contact: [security@arduino.cc](mailto:security@arduino.cc)
