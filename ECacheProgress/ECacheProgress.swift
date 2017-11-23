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
    @IBInspectable var progress: CGFloat = 0.5 {
        didSet {
            progress = min(progress, 1)
            progress = max(progress, 0)
            setNeedsLayout()
        }
    }
    
    //缓冲进度0-1
    @IBInspectable var cacheProgress: CGFloat = 0.6 {
        didSet {
            cacheProgress = min(cacheProgress, 1)
            cacheProgress = max(cacheProgress, 0)
            setNeedsLayout()
        }
    }
    
    //两侧圆角
    @IBInspectable var rounding: Bool = false
    
    //背景色
    @IBInspectable var fullColor: UIColor = UIColor.gray
    
    //进度条颜色
    @IBInspectable var trackColor: UIColor = UIColor.yellow
    
    //缓冲进度条颜色
    @IBInspectable var cacheTrackColor: UIColor = UIColor.red
    
    //中间指示图标
    @IBInspectable var indicatorImage: UIImage?
    
    //是否显示指示图标
    @IBInspectable var showIndicator: Bool = false
    
    //上下缩进去的空立日大
    var progressInsets: UIEdgeInsets = .zero
    
    @IBInspectable var progressInsetX: CGFloat = 0 {
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
    }
    
    open override func prepareForInterfaceBuilder() {
        
    }
}
