# ASBottomSheet

[![CI Status](http://img.shields.io/travis/AdilSoomro/ASBottomSheet.svg?style=flat)](https://travis-ci.org/AdilSoomro/ASBottomSheet)
[![Version](https://img.shields.io/cocoapods/v/ASBottomSheet.svg?style=flat)](http://cocoapods.org/pods/ASBottomSheet)
[![License](https://img.shields.io/cocoapods/l/ASBottomSheet.svg?style=flat)](http://cocoapods.org/pods/ASBottomSheet)
[![Platform](https://img.shields.io/cocoapods/p/ASBottomSheet.svg?style=flat)](http://cocoapods.org/pods/ASBottomSheet)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Screenshot
![enter image description here](https://raw.githubusercontent.com/AdilSoomro/ASBottomSheet/master/screenshot.jpg)


## Installation

ASBottomSheet is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ASBottomSheet"
```
Then import module to your view controller, make a sheet and add items to the sheet and you are done.

```
let first: ASBottomSheetItem = ASBottomSheetItem(withTitle: "Add Image", withIcon: UIImage.init(named: "image_icon")!)
first.action = {
    print("First Action: Add image");
};
let second = ASBottomSheetItem(withTitle: "Add Sticker", withIcon: UIImage.init(named: "sticker_icon")!)
second.action = {
    print("Second Action: Add Sticker");
};
let third = ASBottomSheetItem(withTitle: "Add Image", withIcon: UIImage.init(named: "image_icon")!)
third.action = {
    print("Third Action: Add image");
};

let bottomSheet = ASBottomSheet.menu(withOptions: [first, second, third])
bottomSheet.showMenu(fromViewController: self)

```


## Author

AdilSoomro

Website: [BooleanBites](http://booleanbites.com)

Twitter: [adil_soomro](https://twitter.com/adil_soomro)

## License

ASBottomSheet is available under the MIT license. See the LICENSE file for more info.
