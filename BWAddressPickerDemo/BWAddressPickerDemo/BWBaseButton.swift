//
//  BWBaseButton.swift
//  CommerceSwift
//
//  Created by 熊本丸 on 2019/12/2.
//  Copyright © 2019 xiongbenwan. All rights reserved.
//

import UIKit

class BWBaseButton: UIButton {
    
    /// 纯文字按钮便利构建方法
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - titleFont: 标题字体大小
    ///   - titleColor: 标题颜色
    convenience init(title: String?, titleFont: UIFont?, titleColor: UIColor?) {
        self.init(title: title, titleFont: titleFont, titleColor: titleColor, backgroundColor: UIColor.clear)
    }
    
    /// 带有背景颜色的纯文字按钮便利构建方法
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - titleFont: 标题字体大小
    ///   - titleColor: 标题字体颜色
    ///   - backgroundColor: 背景颜色
    convenience init(title: String?, titleFont: UIFont?, titleColor: UIColor?, backgroundColor: UIColor?) {
        self.init()
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
    }
    
    /// 纯图片按钮便利构建方法
    ///
    /// - Parameters:
    ///   - image: 正常图片
    ///   - highlightImage: 高亮图片
    ///   - selectedImage: 选中图片
    convenience init(image: UIImage?, highlightImage: UIImage?, selectedImage: UIImage?) {
        self.init(image: image, highlightImage: highlightImage, selectedImage: selectedImage, backgroundColor: UIColor.clear)
    }
    
    /// 带背景颜色纯图片按钮便利构建方法
    ///
    /// - Parameters:
    ///   - image: 正常图片
    ///   - highlightImage: 高亮图片
    ///   - selectedImage: 选中图片
    ///   - backgroundColor: 背景颜色
    convenience init(image: UIImage?, highlightImage: UIImage?, selectedImage: UIImage?, backgroundColor: UIColor?) {
        self.init()
        self.image = image
        self.highlightedImage = highlightImage
        self.selectedImage = selectedImage
        self.backgroundColor = backgroundColor
    }
    
    /// 普通带图片按钮便利构建方法
    /// - Parameter image: 图片
    convenience init(image: UIImage?) {
        self.init()
        self.image = image;
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //禁止按钮的高亮状态
        self.adjustsImageWhenHighlighted = false;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
