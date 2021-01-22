<p align="center">
  <img src="https://user-images.githubusercontent.com/11541888/103176751-d6acff00-4874-11eb-8826-836e07369d34.png" alt="dl-buddy icon" title="dl-buddy" height=130>
</p>

# dl-buddy
[![MIT License](https://img.shields.io/badge/License-MIT-blue)](https://opensource.org/licenses/mit-license.php)
[![Platform](http://img.shields.io/badge/platform-macOS-red.svg?style=flat)](https://developer.apple.com/resources/)
[![Platform](https://img.shields.io/badge/swift-5.0-orange.svg?style=flat)](https://swift.org/blog/swift-5-released/)

A simple download manager for macOS written in Swift.

## Features
- [x] Specify URL and destination folder
- [x] Pause, restart and cancel downloads
- [x] Persistent history of all downloads
- [x] Resume downloads even after closing the app

## Screenshots
Main Interface | Add new download
:-------------------------:|:-------------------------:
<img alt="Main Interface" src="https://user-images.githubusercontent.com/11541888/103178658-06640300-4885-11eb-99e9-2c4f77701f08.png"/> | <img alt="Adding a new download" src="https://user-images.githubusercontent.com/11541888/103178622-9eadb800-4884-11eb-83eb-146b69875f3c.png"/>

## Dependencies
* [Alamofire](https://github.com/Alamofire/Alamofire) - Elegant HTTP Networking in Swift

**NOTE:** dependencies are managed automatically using the [Swift Package Manager](https://swift.org/package-manager/) tool which is included in Swift/Xcode.

## Requirements
* macOS >= 10.15 (Catalina)
* Xcode >= 12.2

## Build instructions
1. Clone this repository:
```bash
git clone https://github.com/n3d1117/dl-buddy.git
```
2. Open `dl-buddy.xcodeproj` in Xcode:
```bash
cd dl-buddy/
open dl-buddy.xcodeproj
```
3. Build and run!

## Sample files
| File type       | Size     | Filename     | Direct URL     | Source     |
| :------------- | :----------: | :----------- | :----------- | :----------- |
|  `dmg` | 44 MB   | IINA.v1.1.1.dmg | [Link](https://dl-portal.iina.io/IINA.v1.1.1.dmg)    | https://iina.io |
|  `zip` | 10 MB   | 10mb.zip | [Link](https://www.sample-videos.com/zip/10mb.zip)    | https://sample-videos.com |
|  `pdf` | 5 MB   | Sample-pdf-5mb.pdf | [Link](https://www.sample-videos.com/pdf/Sample-pdf-5mb.pdf)    |https://sample-videos.com|
|  `epub` | 1,1 MB   | aliceDynamic.epub | [Link](https://contentserver.adobe.com/store/books/aliceDynamic.epub)    | https://adobe.com/ |
|  `mp4` | 1 MB   | big_buck_bunny_720p_1mb.mp4 | [Link](https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4)    | https://sample-videos.com |
|  `gif` | 40 KB   | 3.gif | [Link](https://sample-videos.com/gif/3.gif)    | https://sample-videos.com |

## License
MIT License. See [LICENSE](LICENSE) file for further information.