# ImageDownloader

[![CI Status](https://img.shields.io/travis/VladyslavBorysenko/ImageDownloader.svg?style=flat)](https://travis-ci.org/VladyslavBorysenko/ImageDownloader)
[![Version](https://img.shields.io/cocoapods/v/ImageDownloader.svg?style=flat)](https://cocoapods.org/pods/ImageDownloader)
[![License](https://img.shields.io/cocoapods/l/ImageDownloader.svg?style=flat)](https://cocoapods.org/pods/ImageDownloader)
[![Platform](https://img.shields.io/cocoapods/p/ImageDownloader.svg?style=flat)](https://cocoapods.org/pods/ImageDownloader)

## Features 
- [x] Asynchronous image downloading and caching.
- [x] Multiple-layer hybrid cache for both memory and disk.
- [x] Clear all cache
- [x] Reusing previous downloaded content to improve performance.
- [x] View extensions for UIImageView to directly set an image from a URL.
- [x] Custom placeholder while loading images.
- [ ] Animation during the downloading image

## Example

**Most common tasks**

The simplest use-case is setting an image to an image view with the `UIImageView` extension:
```swift
let url = URL(string: "https://example.com/image.png")
imageView.setImage(with: url)
```
QueenFisher will download the image from url, it to both memory cache or disk cache (dependens on free storage on your device ), and display it on imageView. When you set with the same URL later, the image will be retrieved from cache and shown immediately.

**Placeholder**

If you want to set a placeholder, you can use this code below. The image will show in the `imageView` while downloading from url
```swift
imageView.setImage(with: "https://example.com/image.png", placeholder: UIImage(named: placeholder.png))
```

**Image tranformation**

You can also round downloaded image or leave source shape:
```swift
imageView.setImage(with: "https://example.com/image.png", tranformTo: .round)
// tranformTo - shape which we want to change source image
// - .normal - default image shape
// - .rounded - transform image with radius of corners 10
// - .round - tranform source image into circle with radius of corners 50
```
**Image resizinig**

In order to save device resources, you can also scale image to corresponding imageView

```swift
imageView.setImage(with: "https://example.com/image.png", resizeTo: .iconSize)
// resizeTo - set of size values
// - .iconSize - the smallest size, using for icon
// - .cellSize - size for cell in table view 
// - .pictureSize - the biggest size in the set using for banners of image viewing
// - .customSize(Int, Int) - you can also manually set the image size, but the image will save aspect ratio 
```
**Downloading indicator**

To demonstrate the downloading progress, you can set the predefined indicator or set your own path for shape 

```swift
imageView.setImage(with: "https://example.com/image.png", activityIndicator: .heartRate(shapeColor: .black))
// activityIndicator - set of animated shapes
// - .none - no animation
// - .heartRate - animated pulse 
// - .custom - you can set your own path for shape. This shape will be animated
```

**View as a placeholder**

Instead of animation you cat set your custom view with any image ot animation

```swift
let someImageView = UIImageView(image: UIImage(named: "image"))
imageView.setImage(with: "https://example.com/image.png", activityIndicator: .customView(someImageView), completion: nil)
```


## Requirements
- iOS 12.0+
- Swift 5.0+

## Installation

ImageDownloader is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ImageDownloader'
```

## Author

Vladyslav Borysenko, vborisenko@griddynamics.com

## License

ImageDownloader is available under the MIT license. See the LICENSE file for more info.
