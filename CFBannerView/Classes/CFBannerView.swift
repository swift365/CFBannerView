//
//  CFBannerView.swift
//  Pods
//
//  Created by 衡成飞 on 1/7/17.
//
//

import UIKit

@objc public protocol CFBannerViewDelegate{
    @objc optional func didSelectItem(index:Int)
}

@objc public protocol CFBannerViewDataSource{
    func numberOfItems() -> Int
    
    func viewForItem(bannerView:CFBannerView,index:Int) -> UIView
}

public class CFBannerView: UIView,UIScrollViewDelegate {
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var timer: Timer!
    
    public var dataSource: CFBannerViewDataSource!
    public var delegate: CFBannerViewDelegate?
    
    /// 时间间隔
    var autoTimeInterval:Double = 5
    /// 当前选中page的颜色
    var currentPageColor:UIColor = UIColor.white
    /// 未选中page的颜色
    var pageInicatorColor:UIColor = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 0.6)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews(){
     
        self.scrollView = UIScrollView(frame: self.bounds)
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.alwaysBounceVertical = false
        self.scrollView.delegate = self
        self.addSubview(self.scrollView)
        
        self.pageControl = UIPageControl(frame:CGRect(x: 0,y: 0,width: self.frame.size.width,height: 20))
        self.pageControl.center = CGPoint(x:self.frame.size.width/2.0, y:self.frame.size.height - 15)
        self.pageControl.currentPage = 0
        self.addSubview(self.pageControl)
        
        startTimer()
    }
    
    public func startTimer(){
        self.timer = Timer(timeInterval: autoTimeInterval, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    public func nextImage(){
        if dataSource.numberOfItems() != 1{
            var index:Int = pageControl.currentPage
            if index == dataSource.numberOfItems() + 1 {
                index = 0
            }else{
                index += 1
            }
            scrollView.setContentOffset(CGPoint(x: CGFloat(index+1) * scrollView.frame.size.width, y: 0), animated: true)
        }
    }
    
    public func reloadData(){
        let itemCount = dataSource.numberOfItems()
        let subviews = scrollView.subviews
        for v in subviews {
            v.removeFromSuperview()
        }
        
        // 如果数量大于1，需要再增加2个item
        if itemCount <= 1 {
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(itemCount), height: 0)
            pageControl.isHidden = true
        }else{
            scrollView.contentSize = CGSize(width:scrollView.frame.size.width * CGFloat(itemCount+2), height: 0)
            
            // init page control
            pageControl.isHidden = false
            pageControl.numberOfPages = itemCount
            pageControl.currentPage = 0
            pageControl.currentPageIndicatorTintColor = currentPageColor
            pageControl.pageIndicatorTintColor = pageInicatorColor
            
            //将最后一个item放在最前面（不显示）
            let firstView = dataSource.viewForItem(bannerView: self, index: itemCount - 1)
            firstView.frame.origin.x = 0
            
            scrollView.addSubview(firstView)
            
            //将第一个放在最后
            let lastView = dataSource.viewForItem(bannerView: self, index: 0)
            lastView.frame.origin.x = scrollView.frame.size.width * CGFloat(itemCount+1)
            scrollView.addSubview(lastView)
            
            //设置显示的开始位置，从真正的第一个开始
            scrollView.contentOffset = CGPoint(x:scrollView.frame.size.width, y:0)
        }
        
        for i in 0..<itemCount {
            let item = dataSource.viewForItem(bannerView: self, index: i)
            item.tag = i + 500
            
            item.frame.origin.x = scrollView.frame.size.width * CGFloat(i)
            //如果数量大于1，则从后一个位置开始
            if itemCount > 1 {
                item.frame.origin.x = scrollView.frame.size.width * CGFloat(i+1)
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapItem(tap:)))
            item.isUserInteractionEnabled = true
            item.addGestureRecognizer(tap)
            scrollView.addSubview(item)
        }
    }
    
    // MARK: - BannerViewProtocol
    public func tapItem(tap:UITapGestureRecognizer){
        let index = tap.view!.tag - 500
        if delegate != nil {
            delegate!.didSelectItem!(index: index)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    // 开始拖动时，自动播放失效
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    // 停止拖动时，则开始自动滑动
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    // 已经滑动
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let itemCount = dataSource.numberOfItems()
        var index:Int = Int((scrollView.contentOffset.x + scrollView.frame.size.width * 0.5) / scrollView.frame.size.width)
        
        //如果滑动到最后一个的后面，则回到第一个
        if index == itemCount + 2 {
            index = 1
        }else if index == 0 {
            index = itemCount
        }
        self.pageControl.currentPage = index - 1
    }

    // 减速停止
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(scrollView)
    }
    
    //滚动动画停止时执行,代码改变时触发,也就是setContentOffset改变时
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        let index:Int = Int((scrollView.contentOffset.x + scrollView.frame.size.width * 0.5) / scrollView.frame.size.width)
        if index == dataSource.numberOfItems() + 1 {
            scrollView.setContentOffset(CGPoint(x:width, y:0), animated: false)
        }else if index == 0 {
            scrollView.setContentOffset(CGPoint(x:CGFloat(dataSource.numberOfItems()) * width, y:0), animated: false)
        }
    }
}
