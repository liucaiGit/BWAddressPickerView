//
//  UIColorExtension.swift
//  SwiftDemo
//
//  Created by 熊本丸 on 2019/11/14.
//  Copyright © 2019 xiongbenwan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    /// 十六进制颜色c转化成UIColor
    ///
    /// - Parameter hexColorString: 十六进制颜色
    convenience init(hexColorString: String) {
        let hexString = hexColorString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1;
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color);
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        self.init(red:CGFloat(r), green:CGFloat(g), blue:CGFloat(b))
    }
    
    /// 简便RGB颜色构造器  默认透明度为1
    ///
    /// - Parameters:
    ///   - red: red色值
    ///   - green: green色值
    ///   - blue: blue色值
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(r: red, g: green, b: blue, alpha:1)
    }
    
    /// 简便RGB颜色构造器
    ///
    /// - Parameters:
    ///   - r: red色值
    ///   - g: green色值
    ///   - b: blue色值
    ///   - alpha: 透明度 0~1
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
