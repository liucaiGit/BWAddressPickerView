//
//  UIView+Extension.swift
//  SwiftDemo
//
//  Created by 熊本丸 on 2019/11/15.
//  Copyright © 2019 xiongbenwan. All rights reserved.
//

import Foundation
import UIKit

public enum BWShadowPosition {
    case top
    case bottom
    case left
    case right
    case common
    case around
}

//MARK: Properties
extension UIView {
    
    
    public var x: CGFloat {
        set {
            var rect: CGRect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
        get {
            return self.frame.origin.x
        }
    }
    public var y: CGFloat {
        set {
            var rect: CGRect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
        get {
            return self.frame.origin.y
        }
    }
    public var maxX: CGFloat {
        set {
            self.x = newValue - self.width
        }
        get {
            return self.frame.maxX
        }
    }
    public var maxY: CGFloat {
        set {
            self.y = newValue - self.height
        }
        get {
            return self.frame.maxY
        }
    }
    public var width: CGFloat {
        set {
            var rect: CGRect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
        get {
            return self.frame.size.width
        }
    }
    public var height: CGFloat {
        set {
            var rect: CGRect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
        get {
            return self.frame.size.height
        }
    }
    public var centerX: CGFloat {
        set {
            var center: CGPoint = self.center
            center.x = newValue
            self.center = center
        }
        get {
            return self.center.x
        }
    }
    public var centerY: CGFloat {
        set {
            var center: CGPoint = self.center
            center.y = newValue
            self.center = center
        }
        get {
            return self.center.y
        }
    }
    public var size: CGSize {
        set {
            var rect: CGRect = self.frame
            rect.size = newValue
            self.frame = rect
        }
        get {
            return self.frame.size
        }
    }
}

extension UIView {
    private struct CWAssociatedKey {
        //indexPath key
        static var CWIndexPathAssociatedKey: String = "CWIndexPathAssociatedKey"
    }
    //添加indexPath属性
    public var indexPath: IndexPath {
        get {
            return objc_getAssociatedObject(self, &CWAssociatedKey.CWIndexPathAssociatedKey) as! IndexPath
        }
        set {
            objc_setAssociatedObject(self, &CWAssociatedKey.CWIndexPathAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

// MARK: - Function
extension UIView {
    
    /// 按照原尺寸转化成图片
    ///
    /// - Returns: 转化成功的图片
    open func transformToImage() -> UIImage {
        self.layoutSubviews()
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0);
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return image;
    }
    
    /// 添加圆角
    ///
    /// - Parameter cornerRadii: 圆角大小
    open func addAllRoundingCornersWithRadii(cornerRadii: CGSize) {
        self.addBezierPathCorner(roundingCorners: UIRectCorner.allCorners, cornerRadii: cornerRadii)
    }
    
    /// 添加圆角
    ///
    /// - Parameters:
    ///   - roundingCorners: 圆角区域
    ///   - radii: 圆角大小
    open func addBezierPathCorner(roundingCorners: UIRectCorner, cornerRadii radii: CGSize) {
        if superview != nil {
            superview?.layoutIfNeeded()
        }
        let bezierPath: UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: radii)
        let shapeLayer: CAShapeLayer = CAShapeLayer.init()
        shapeLayer.frame = self.bounds
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
    
    /// 添加阴影
    ///
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - opacity: 阴影透明度
    ///   - radius: 圆角
    ///   - offset: 阴影偏移量
    ///   - width: 阴影宽度
    ///   - position: 添加阴影的位置
    open func shadowPathWithColor(_ color: UIColor, opacity: CGFloat?, radius: CGFloat, offset: CGSize?, width: CGFloat, position: BWShadowPosition) {
        if self.superview != nil {
            self.superview?.layoutIfNeeded()
        }
        //避免阴影被切割隐藏
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        //阴影透明度 默认为0
        self.layer.shadowOpacity = Float(opacity ?? 0.0)
        //阴影便宜量  默认为(0,-3)
        self.layer.shadowOffset = offset ?? CGSize.init(width: 0, height: -3)
        //阴影半径 默认为3
        self.layer.cornerRadius = radius
        
        var shadowRect = CGRect.zero
        let originX: CGFloat = 0
        let originY: CGFloat = 0
        let sizeWidth: CGFloat = self.width
        let sizeHeight: CGFloat = self.height
        switch position {
        case .top: do {
            shadowRect = CGRect.init(x: originX, y: originY - width / 2.0, width: sizeWidth, height: width)
            }
        case .left: do {
            shadowRect = CGRect.init(x: originX - width / 2.0, y: originY, width: width, height: sizeHeight)
            }
        case .bottom: do {
            shadowRect = CGRect.init(x: originY, y: sizeHeight - width / 2.0, width: sizeWidth, height: width)
            }
        case .right: do {
            shadowRect = CGRect.init(x: sizeWidth - width / 2.0, y: originY, width: width, height: sizeHeight)
            }
        case .common: do {
            shadowRect = CGRect.init(x: originX - width / 2.0, y: 2, width: sizeWidth+width, height: sizeHeight + width / 2.0)
            }
        case .around: do {
            shadowRect = CGRect.init(x: originX - width / 2.0, y: originY - width / 2.0, width: sizeWidth + width, height: sizeHeight + width)
            }
        }
        let bezierPath: UIBezierPath = UIBezierPath.init(rect: shadowRect)
        self.layer.shadowPath = bezierPath.cgPath
    }
}
