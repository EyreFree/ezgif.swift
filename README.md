# ezgif.swift

[![CI Status](https://img.shields.io/travis/eyrefree/ezgif.swift.svg?style=flat)](https://travis-ci.org/eyrefree/ezgif.swift)
[![Version](https://img.shields.io/cocoapods/v/ezgif.swift.svg?style=flat)](https://cocoapods.org/pods/ezgif.swift)
[![License](https://img.shields.io/cocoapods/l/ezgif.swift.svg?style=flat)](https://cocoapods.org/pods/ezgif.swift)
[![Platform](https://img.shields.io/cocoapods/p/ezgif.swift.svg?style=flat)](https://cocoapods.org/pods/ezgif.swift)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ezgif.swift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ezgif.swift'
```

## Usage

```swift
let imageTodoUrl: String = "https://img.zcool.cn/community/01639c586c91bba801219c77f6efc8.gif"
Ezgif.shared.optimize(imageUrl: imageTodoUrl) { newFileUrl, error in
    if let error = error {
        printLog("Ezgif.shared.optimize error: \(error.localizedDescription)")
    } else {
        printLog("Ezgif.shared.optimize newFileUrl: \(newFileUrl ?? "")")
    }
}
```

## Author

EyreFree, eyrefree@eyrefree.org

## License

ezgif.swift is available under the MIT license. See the LICENSE file for more info.
