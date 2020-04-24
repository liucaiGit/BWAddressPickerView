//
//  Defines.swift
//  BWAddressPickerDemo
//
//  Created by 机惠购 on 2020/4/24.
//  Copyright © 2020 熊本丸. All rights reserved.
//

import Foundation
import UIKit

//状态栏高度
let BWStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
//导航栏高度
let BWNavigationBarHeight: CGFloat = (BWStatusBarHeight + 44)
//标签栏高度
let BWTabBarHeight: CGFloat = BWStatusBarHeight > 20 ? 83 : 49
//底部安全区域高度
let BWTabBarBottomHeight: CGFloat = BWStatusBarHeight > 20 ? 34 : 0
//顶部新增高度
let BWStatusBarTopHeght: CGFloat = BWStatusBarHeight > 20 ? 24 : 0
//屏幕宽度
let BWScreenWidth: CGFloat = UIScreen.main.bounds.width
//屏幕高度
let BWScreenHeight: CGFloat = UIScreen.main.bounds.height


//333333颜色
let color333333: UIColor = UIColor.init(hexColorString: "#3333333")
//666666颜色
let color666666: UIColor = UIColor.init(hexColorString: "#666666")
//999999颜色
let color999999: UIColor = UIColor.init(hexColorString: "#999999")


//MARK: UIFont

/// 设置系统字号
/// - Parameter fontSize: 字号
public func BWSystemRegularFont(fontSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontSize)
}

/// 设置中粗字号
/// - Parameter fontSize: 中粗字号
public func BWSystemMediumFont(fontSize: CGFloat) -> UIFont {
    return BWFont(fontName: "PingFang-SC-Medium", fontSzie: fontSize)
}

/// 设置粗体字号
/// - Parameter fontSize: 粗体字号
public func BWSystemBoldFont(fontSize: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: fontSize)
}

/// 根据字体名&字号生成字体对象
/// - Parameters:
///   - fontName: 字体名称
///   - fontSzie: 字号
public func BWFont(fontName: String, fontSzie: CGFloat) -> UIFont {
    return UIFont.init(name: fontName, size: fontSzie) ?? UIFont.init()
}

//MARK: UIColor

/// 根据RGB生成颜色
/// - Parameters:
///   - r: red色值
///   - g: green色值
///   - b: blue色值
public func BWRGBColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return UIColor.init(red: r, green: g, blue: b)
}

/// 根据十六进制颜色生成颜色
/// - Parameter colorString: 十六进制颜色
public func BWHexColor(_ colorString: String) -> UIColor {
    return UIColor.init(hexColorString: colorString)
}

//MARK: 比例计算高宽

/// 按照屏幕宽按比例计算宽度
/// - Parameter width: 宽度
public func BWScreenScaleWidth(width: CGFloat) -> CGFloat {
    return width * (BWScreenWidth / 375.0)
}

/// 按照屏幕高度比例计算高度
/// - Parameter height: 高度
public func BWScreenScaleHeight(height: CGFloat) -> CGFloat {
    return height * (BWScreenHeight / 667.0)
}
