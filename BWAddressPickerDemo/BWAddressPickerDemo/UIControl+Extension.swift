//
//  UIControl+Extension.swift
//  SwiftDemo
//
//  Created by 熊本丸 on 2019/11/14.
//  Copyright © 2019 xiongbenwan. All rights reserved.
//

import Foundation
import UIKit

/// 按钮图片位置枚举
///
/// - left: 图片在左
/// - right: 图片在右
/// - top: 图片在上
/// - bottom: 图片在下
enum BWButtonImagePosition {
    case left
    case right
    case top
    case bottom
}

extension UIControl {
    open func addTarget(_ target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}

extension UIControl {
    //扩大点击区域  最大为44*44
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds: CGRect = self.bounds;
        //若原热区小于44x44，则放大热区，否则保持原大小不变
        let widthDelta: CGFloat = max(44.0 - bounds.size.width, 0)
        let heightDelta: CGFloat  = max(44.0 - bounds.size.height, 0);
        bounds = bounds.insetBy(dx: -0.5*widthDelta, dy: -0.5*heightDelta)
        let isContain: Bool = bounds.contains(point)
        return isContain;
    }
}

extension UIButton {
    //MARK:titleColor highlightedTitleColor selectedTitleColor disabledTitleColor
    //normal状态
    public var titleColor: UIColor? {
        set {
            self.setTitleColor(newValue, for: .normal)
        }
        get {
            return self.titleColor(for: .normal)
        }
    }
    //highlighted状态
    public var highlightedTitleColor: UIColor? {
        set {
            self.setTitleColor(newValue, for: .highlighted)
        }
        get {
            return self.titleColor(for: .highlighted)
        }
    }
    //selected状态
    public var selectedTitleColor: UIColor? {
        set {
            self.setTitleColor(newValue, for: .selected)
        }
        get {
            return self.titleColor(for: .selected)
        }
    }
    //disabled状态
    public var disabledTitleColor: UIColor? {
        set {
            self.setTitleColor(newValue, for: .disabled)
        }
        get {
            return self.titleColor(for: .disabled)
        }
    }

    //MARK:title highlightedTitle selectedTitle disabledTitle
    //normal状态
    public var title: String? {
        set {
            self.setTitle(newValue, for: .normal)
        }
        get {
            return self.title(for: .normal)
        }
    }
    //highlighted状态
    public var highlightedTitle: String? {
        set {
            self.setTitle(newValue, for: .highlighted)
        }
        get {
            return self.title(for: .highlighted)
        }
    }
    //selected状态
    public var selectedTitle: String? {
        set {
            self.setTitle(newValue, for: .selected)
        }
        get {
            return self.title(for: .selected)
        }
    }
    
    //disabled状态
    public var disabledTitle: String? {
        set {
            self.setTitle(newValue, for: .disabled)
        }
        get {
            return self.title(for: .disabled)
        }
    }
    
    //MARK:image highlightedImage selectedImage disabledImage
    //normal状态
    public var image: UIImage? {
        set {
            self.setImage(newValue, for: .normal)
        }
        get {
            return self.image(for: .normal)
        }
    }
    //highlighted状态
    public var highlightedImage: UIImage? {
        set {
            self.setImage(newValue, for: .highlighted)
        }
        get {
            return self.image(for: .highlighted)
        }
    }
    //selected状态
    public var selectedImage: UIImage? {
        set {
            self.setImage(newValue, for: .selected)
        }
        get {
            return self.image(for: .selected)
        }
    }
    
    //disabled状态
    public var disabledImage: UIImage? {
        set {
            self.setImage(newValue, for: .disabled)
        }
        get {
            return self.image(for: .disabled)
        }
    }
    
    //MARK:bgImage highlightedBgImage selectedBgImage
    //normal状态
    public var bgImage: UIImage? {
        set {
            self.setBackgroundImage(newValue, for: .normal)
        }
        get {
            return self.backgroundImage(for: .normal)
        }
    }
    //highlighted状态
    public var highlightedBgImage: UIImage? {
        set {
            self.setBackgroundImage(newValue, for: .highlighted)
        }
        get {
            return self.backgroundImage(for: .highlighted)
        }
    }
    //selected状态
    public var selectedBgImage: UIImage? {
        set {
            self.setBackgroundImage(newValue, for: .selected)
        }
        get {
            return self.backgroundImage(for: .selected)
        }
    }
    
    //disabled状态
    public var disabledBgImage: UIImage? {
        set {
            self.setBackgroundImage(newValue, for: .disabled)
        }
        get {
            return self.backgroundImage(for: .disabled)
        }
    }
    
    //titleFont
    public var titleFont: UIFont? {
        set {
            self.titleLabel?.font = newValue
        }
        get {
            return self.titleLabel?.font
        }
    }
}

//extension UIButton {
//    
//    /// 设置图片位置以及图片与文字之间的间距(如果使用layout布局，需先调用父视图的layoutIfNeeded)
//    ///
//    /// - Parameters:
//    ///   - positon: 图片位置
//    ///   - spacing: 图片间隙
//    func buttonImagePosition(_ positon: BWButtonImagePosition, spacing: CGFloat) {
//        //图片视图宽高
//        let imageWidth = self.imageView?.width ?? 0.0
//        let imageHeight = self.imageView?.height ?? 0.0
//        //文字 此处不使用（self.titleLabel.bounds.size.width 为 0）
//        let titleWidth = self.titleLabel?.text?.boundingRectWithSize(self.size, font: self.titleFont ?? BWSystemRegularFont(fontSize: 17)).width ?? 0.0
//        let titleHeight = self.titleLabel?.text?.boundingRectWithSize(self.size, font: self.titleFont ?? BWSystemRegularFont(fontSize: 17)).height ?? 0.0
//        
//        //图片中心 X/Y 偏移量
//        let imageOffsetX = (imageWidth + titleWidth) / 2.0 - imageWidth / 2.0;
//        let imageOffsetY = imageHeight / 2.0 + spacing / 2.0;
//        
//        //标题中心 X/Y 偏移量
//        let width = imageWidth + titleWidth / 2.0
//        let halfWidth = (imageWidth + titleWidth) / 2.0
//        let titleOffsetX = width - halfWidth
//        let titleOffsetY = titleHeight / 2 - spacing / 2
//        
//        switch positon {
//        case .left:
//            //图片在左
//            self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -spacing / 2.0, bottom: 0, right: spacing / 2.0)
//            self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: spacing / 2.0, bottom: 0, right: -spacing / 2.0)
//        case .right:
//            //图片在右
//            self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: titleWidth + spacing / 2.0, bottom: 0, right: -(titleWidth + spacing / 2.0))
//            self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(imageWidth + spacing / 2.0), bottom: 0, right: (imageWidth + spacing / 2.0))
//        case .top:
//            //图片在上
//            self.imageEdgeInsets = UIEdgeInsets.init(top: -(imageOffsetY + spacing / 2.0), left: imageOffsetX, bottom: imageOffsetY + spacing / 2.0, right: -imageOffsetX)
//            self.titleEdgeInsets = UIEdgeInsets.init(top: titleOffsetY + spacing / 2.0, left: -titleOffsetX, bottom: -(titleOffsetY + spacing / 2.0), right: titleOffsetX)
//        case .bottom:
//            //图片在下
//            self.imageEdgeInsets = UIEdgeInsets.init(top: imageOffsetY + spacing / 2.0, left: imageOffsetX, bottom: -(imageOffsetY + spacing / 2.0), right: -imageOffsetX)
//            self.titleEdgeInsets = UIEdgeInsets.init(top: -(titleOffsetY + spacing / 2.0), left: -titleOffsetX, bottom: titleOffsetY + spacing / 2.0, right: titleOffsetX)
//        }
//    }
//}
