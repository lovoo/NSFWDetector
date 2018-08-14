# NSFWDetector

[![Version](https://img.shields.io/cocoapods/v/NSFWDetector.svg?style=flat)](https://cocoapods.org/pods/NSFWDetector)
[![License](https://img.shields.io/cocoapods/l/NSFWDetector.svg?style=flat)](https://cocoapods.org/pods/NSFWDetector)
[![Platform](https://img.shields.io/cocoapods/p/NSFWDetector.svg?style=flat)](https://cocoapods.org/pods/NSFWDetector)

NSFWDetector is able to scan images for nudity. It was trained using CreateML to distinguish between porn/nudity and appropriate pictures. With the main focus on distinguishing between instagram model like pictures and porn.

## Usage

```swift
guard #available(iOS 12.0, *), let detector = NSFWDetector.shared else {
    return
}

detector.check(image: image, completion: { result in
    switch result {
    case let .success(nsfwConfidence: confidence):
        if confidence > 0.9 {
            // 😱🙈😏
        } else {
            // ¯\_(ツ)_/¯
        }
    default:
        break
    }
})
```

If you want to enforce stricter boundaries for your platform, just apply a lower threshold for the confidence.

## Installation

NSFWDetector is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NSFWDetector', :git => 'https://github.com/lovoo/NSFWDetector.git'
```

## Using the Model

Just download the MLModel file from the latest [Release](https://github.com/lovoo/NSFWDetector/releases)

## Author

Michael Berg, michael.berg@lovoo.com

## License

NSFWDetector is available under the BSD license. See the LICENSE file for more info.
