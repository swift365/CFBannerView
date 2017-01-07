# CFBannerView

[![CI Status](http://img.shields.io/travis/chengfei.heng/CFBannerView.svg?style=flat)](https://travis-ci.org/chengfei.heng/CFBannerView)
[![Version](https://img.shields.io/cocoapods/v/CFBannerView.svg?style=flat)](http://cocoapods.org/pods/CFBannerView)
[![License](https://img.shields.io/cocoapods/l/CFBannerView.svg?style=flat)](http://cocoapods.org/pods/CFBannerView)
[![Platform](https://img.shields.io/cocoapods/p/CFBannerView.svg?style=flat)](http://cocoapods.org/pods/CFBannerView)

## Example
<img src="https://github.com/swift365/CFCenterItemViews/blob/master/Example/CFCenterItemViews/shot.png"  alt="效果展示" height="568" width="320" />

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Use
```swift
let bannerView = CFBannerView(frame:frame)
bannerView.dataSource = self
bannerView.delegate = self
bannerView.reloadData()
        
extension ViewController:CFBannerViewDataSource,CFBannerViewDelegate{
    func numberOfItems() -> Int {
        return banners.count
    }
    
    func viewForItem(bannerView: CFBannerView, index: Int) -> UIView {
        let imageView = UIImageView(frame: bannerView.bounds)
        imageView.sd_setImage(with: URL(string: banners[index]), placeholderImage: UIImage(named: "default"))
 
        return imageView
    }
    
    func didSelectItem(index: Int) {
        print(index)
    }
}
```

## Requirements

## Installation

CFBannerView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CFBannerView"
```

## Author

chengfei.heng, hengchengfei@sina.com

## License

CFBannerView is available under the MIT license. See the LICENSE file for more info.
