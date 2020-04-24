//
//  BWAddressModel.swift
//  CommerceSwift
//
//  Created by xiongbenwan on 2020/4/22.
//  Copyright © 2020 xiongbenwan. All rights reserved.
//

import UIKit
import HandyJSON

class BWAddressModel: NSObject, HandyJSON {
    required override init(){}
    //标题
    var title: String?
    //regions_id
    var regions_id: String?
    //parent_id
    var parent_id: String?
    //is_hot
    var is_hot: Bool = false
    //编码
    var code: String?
    //省下级市数据
    var child: [BWAddressCityModel] = [BWAddressCityModel]()
}

//市model
class BWAddressCityModel: NSObject, HandyJSON {
    required override init(){}
    //标题
    var title: String?
    //regions_id
    var regions_id: String?
    //parent_id
    var parent_id: String?
    //is_hot
    var is_hot: Bool = false
    //编码
    var code: String?
    //市下级区数据
    var child: [BWAddressAreaModel] = [BWAddressAreaModel]()
}

//区model
class BWAddressAreaModel: NSObject, HandyJSON {
    required override init(){}
    //标题
    var title: String?
    //regions_id
    var regions_id: String?
    //parent_id
    var parent_id: String?
    //is_hot
    var is_hot: Bool = false
    //编码
    var code: String?
}
