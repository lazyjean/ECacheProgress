//
//  ECacheProgress.swift
//  ECacheProgress
//
//  Created by 刘真 on 2017/11/22.
//

import UIKit

@IBDesignable

open class ECacheProgress: UIControl {

    //进度0-1
    @IBInspectable public var progress: CGFloat = 0.5 {
        didSet {
            progress = min(progress, 1)
            progress = max(progress, 0)
            if dragging == false {
                setNeedsLayout()
            }
        }
    }
    
    //缓冲进度0-1
    @IBInspectable public var cacheProgress: CGFloat = 0.6 {
        didSet {
            cacheProgress = min(cacheProgress, 1)
            cacheProgress = max(cacheProgress, 0)
            if dragging == false {
                setNeedsLayout()
            }
        }
    }
    
    //两侧圆角
    @IBInspectable public var rounding: Bool = false
    
    //背景色
    @IBInspectable public var fullColor: UIColor = UIColor.gray
    
    //进度条颜色
    @IBInspectable public var trackColor: UIColor = UIColor.yellow
    
    //缓冲进度条颜色
    @IBInspectable public var cacheTrackColor: UIColor = UIColor.red
    
    //中间指示图标
    @IBInspectable public var indicatorImage: UIImage?
    
    //是否显示指示图标
    @IBInspectable public var showIndicator: Bool = false
    
    //上下缩进去的空立日大
    var progressInsets: UIEdgeInsets = .zero
    
    @IBInspectable public var progressInsetX: CGFloat = 0 {
        didSet {
            progressInsets.top = progressInsetX
            progressInsets.bottom = progressInsetX
            setNeedsLayout()
        }
    }
    
    private var cacheProgressView = UIView()
    private var cacheProgressMask = UIView()
    private var progressView = UIView()
    private var progressMask = UIView()
    private var fullView = UIView()
    private var indicator = UIImageView()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if cacheProgressView.superview == nil, cacheProgressView.superview == nil, fullView.superview == nil, indicator.superview == nil {
            cacheProgressMask.addSubview(cacheProgressView)
            progressMask.addSubview(progressView)
            addSubview(fullView)
            addSubview(cacheProgressMask)
            addSubview(progressMask)
            addSubview(indicator)
        }
        
        //设置view颜色
        fullView.backgroundColor = fullColor
        cacheProgressView.backgroundColor = cacheTrackColor
        cacheProgressMask.clipsToBounds = true
        progressView.backgroundColor = trackColor
        progressMask.clipsToBounds = true
        indicator.image = indicatorImage
        
        //计算大小
        var contentSize = self.frame.size
        var indicatorSize = CGSize(width: 0, height: 0)
        let progressHeight = self.frame.size.height - self.progressInsets.top - self.progressInsets.bottom
        
        //添加圆角
        if rounding {
            let radius = progressHeight/2.0

            fullView.layer.cornerRadius = radius
            fullView.clipsToBounds = true
            
            cacheProgressView.layer.cornerRadius = radius
            cacheProgressView.clipsToBounds = true
            
            progressView.layer.cornerRadius = radius
            progressView.clipsToBounds = true
        }
        
        //如果设置了指器则调整大小
        if let img = indicatorImage {
            contentSize.width = max(contentSize.width, img.size.width)
            contentSize.height = max(contentSize.height, img.size.height)
            indicatorSize = img.size
            
            let min = (indicatorSize.width - progressHeight)/2.0
            progressInsets.left = max(progressInsets.left, min)
            progressInsets.right = max(progressInsets.right, min)
        }
        
        //设置大小
        fullView.frame = UIEdgeInsetsInsetRect(self.bounds, self.progressInsets)
        cacheProgressView.frame = fullView.bounds
        cacheProgressMask.frame = fullView.frame
        
        progressView.frame = fullView.bounds
        progressMask.frame = fullView.frame
        
        var frame = cacheProgressMask.frame
        frame.size.width = frame.width * cacheProgress
        cacheProgressMask.frame = frame
        
        frame = progressMask.frame
        frame.size.width = frame.width * progress
        progressMask.frame = frame
        
        indicator.frame = CGRect(origin: .zero, size: indicatorSize)
        indicator.center = CGPoint(x: progressMask.frame.maxX, y: progressMask.frame.midY)
    }
    
    var touching: UITouch?
    var timer: Timer?
    var moveTrackBar: DispatchWorkItem?
    var dragging: Bool = false
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        touching = touches.first
        let item = DispatchWorkItem { [weak self] in
            if let full = self?.fullView, let pt = self?.touching?.location(in: full) {
                self?.dragging = true
                self?.progress = pt.x/full.frame.size.width
                self?.setNeedsLayout()
            }
        }
        
        //延时调用
        let (seconds, frac) = modf(Date().timeIntervalSince1970 + 0.5)
        let nsec: Double = frac*Double(NSEC_PER_SEC)
        let walltime = timespec(tv_sec: Int(seconds), tv_nsec: Int(nsec))
        let time = DispatchWallTime(timespec: walltime)
        DispatchQueue.main.asyncAfter(wallDeadline: time, execute: item)
        
        self.moveTrackBar = item
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let item = moveTrackBar, !item.isCancelled {
            item.cancel()
        }
        
        if let pt = self.touching?.location(in: self.fullView) {
            self.dragging = true
            progress = pt.x/fullView.frame.size.width
            setNeedsLayout()
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let item = moveTrackBar, !item.isCancelled {
            item.cancel()
        }
        
        self.dragging = false
        setNeedsLayout()
        self.sendActions(for: UIControlEvents.valueChanged)
    }
    
    open override func prepareForInterfaceBuilder() {
        
    }
}
