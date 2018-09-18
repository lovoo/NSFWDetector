# ![NSFWDetector](https://github.com/lovoo/NSFWDetector/blob/master/assets/header.png?raw=true)

[![Version](https://img.shields.io/cocoapods/v/NSFWDetector.svg?style=flat)](https://cocoapods.org/pods/NSFWDetector)
[![License](https://img.shields.io/cocoapods/l/NSFWDetector.svg?style=flat)](https://cocoapods.org/pods/NSFWDetector)
[![Platform](https://img.shields.io/cocoapods/p/NSFWDetector.svg?style=flat)](https://cocoapods.org/pods/NSFWDetector)

NSFWDetector is a small (**17 kB**) CoreML Model to scan images for nudity. It was trained using CreateML to distinguish between porn/nudity and appropriate pictures. With the main focus on distinguishing between instagram model like pictures and porn.

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
pod 'NSFWDetector'
```

⚠️ Because the model was trained with CreateML, you need **Xcode 10** and above to compile the project.

## App Size

The Machine Learning Model is only **17 kB** in size, so App size won't be affected compared to other libraries using the [yahoo model](https://github.com/yahoo/open_nsfw).

## Using just the Model

If you don't want to use the Detection Code, you can also just download the MLModel file directly from the latest [Release](https://github.com/lovoo/NSFWDetector/releases).

## Feedback

If you recognize issues with certain kind of pictures, feel free to reach out via [Mail](mailto:michael.berg@lovoo.com) or [Twitter](https://twitter.com/LOVOOEng).

## Author

Michael Berg, [michael.berg@lovoo.com](mailto:michael.berg@lovoo.com)

## License

NSFWDetector is available under the BSD license. See the LICENSE file for more info.
