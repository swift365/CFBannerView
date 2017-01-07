//
//  ViewController.swift
//  CFBannerView
//
//  Created by chengfei.heng on 01/07/2017.
//  Copyright (c) 2017 chengfei.heng. All rights reserved.
//

import UIKit
import CFBannerView
import SDWebImage

class ViewController: UIViewController {

    var banner:UIView!
    
    let banners = ["http://pic.58pic.com/58pic/13/72/07/55Z58PICKka_1024.jpg",
                   "http://pic.qiantucdn.com/58pic/18/13/67/72w58PICshJ_1024.jpg",
                   "http://h.hiphotos.baidu.com/zhidao/pic/item/024f78f0f736afc396060dbbb119ebc4b64512e1.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "轮播banner"
      
        let banner = UIView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 170))
        self.view.addSubview(banner)
        
        var frame = banner.frame
        frame.origin.y = 0
        
        let bannerView = CFBannerView(frame:frame)
        bannerView.dataSource = self
        bannerView.delegate = self
        bannerView.reloadData()
        
        banner.addSubview(bannerView)
    }
}

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
