//
//  JsonUtil.swift
//  CommerceSwift
//
//  Created by 熊本丸 on 2019/12/3.
//  Copyright © 2019 xiongbenwan. All rights reserved.
//

import UIKit
import HandyJSON

/// json处理
class BWJsonUtil<T: HandyJSON>: NSObject {
    
    /// jsonDic -> model
    ///
    /// - Parameter jsonDic: 字典
    /// - Returns: 自定义model
    static func modelFromJsonDic(_ jsonDic: [String: Any]) -> T? {
        if jsonDic.count == 0 {
            print("传入的json字典为空")
            return nil
        }
        return JSONDeserializer<T>.deserializeFrom(dict: jsonDic)
    }
    
    /// jsonDic -> 自定义model
    ///
    /// - Parameters:
    ///   - jsonDic: json字符串
    ///   - designatedPath: 路由
    /// - Returns: 自定义模型
    static func modelFromJsonDic(_ jsonDic: [String: Any], designatedPath: String) -> T? {
        return JSONDeserializer<T>.deserializeFrom(dict: jsonDic, designatedPath: designatedPath)
    }
    
    /// jsonArray -> 自定义模型数组
    ///
    /// - Parameter jsonArr: json数组
    /// - Returns: 自定义属性数组
    static func modelArrayFromJsonArray(_ jsonArr: [Any]) -> [T]? {
        if jsonArr.isEmpty == true {
            print("传入的json数组为空")
            return nil
        }
        return JSONDeserializer<T>.deserializeModelArrayFrom(array: jsonArr) as? [T]
    }
    
    /// jsonString -> model
    /// - Parameters:
    ///   - jsonString: json字符串
    static func modelFromJsonString(_ jsonString: String) -> T? {
        if jsonString == "" || jsonString.count == 0 {
            print("传入的json字符串为空");
            return nil
        }
        return JSONDeserializer<T>.deserializeFrom(json: jsonString)
    }
    
    /// JsonString -> model
    ///
    /// - Parameters:
    ///   - jsonString: jsonString
    ///   - designatedPath: 路由
    /// - Returns: 自定义模型
    static func modelFromJsonString(_ jsonString: String, designatedPath: String) -> T? {
        return JSONDeserializer<T>.deserializeFrom(json: jsonString, designatedPath: designatedPath)
    }
    
    /// json字符串 -> 自定义模型数组
    /// - Parameters:
    ///   - jsonString: json字符串
    ///   - modelType: 自定义模型类型
    static func modelArrayFromJsonString(_ jsonString: String) -> [T]? {
        if jsonString == "" || jsonString.count == 0 {
            print("传入的json字符串为空")
            return nil
        }
        return JSONDeserializer<T>.deserializeModelArrayFrom(json: jsonString) as? [T]
    }
    
    /// jsonString -> 自定义模型数组
    ///
    /// - Parameters:
    ///   - jsonString: json字符串
    ///   - designatedPath: 路由
    /// - Returns: 自定义模型数组
    static func modelArrayFromJsonString(_ jsonString: String, designatedPath: String) -> [T]? {
        return JSONDeserializer<T>.deserializeModelArrayFrom(json: jsonString, designatedPath: designatedPath) as? [T]
    }
    
    /// 自定义模型 -> json字符串
    /// - Parameter model: 自定义模型
    static func jsonStringFromModel(_ model: T?) -> String {
        if model == nil {
            print("传入的模型为nil")
            return ""
        }
        return (model?.toJSONString())!
    }
    
    /// 自定义模型 -> 字典
    /// - Parameter model: 模型
    static func jsonDicFromModel(_ model: T?) -> [String: Any] {
        if model == nil {
            print("传入的模型为nil")
            return [:]
        }
        return (model?.toJSON())!
    }
}
