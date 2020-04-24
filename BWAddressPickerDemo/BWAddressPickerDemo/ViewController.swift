//
//  ViewController.swift
//  BWAddressPickerDemo
//
//  Created by xiongbenwan on 2020/4/24.
//  Copyright © 2020 熊本丸. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //pickerView
    private lazy var addressPickerView: BWAddressPickerView = {
        return BWAddressPickerView(defaultRegions: ("浙江省", "湖州市", "长兴县"))
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let provinceButton: BWBaseButton = BWBaseButton.init(title: "省", titleFont: BWSystemRegularFont(fontSize: 14), titleColor: .white)
        provinceButton.tag = 10000
        provinceButton.addTarget(self, action: #selector(addressShowBtn(_:)))
        provinceButton.frame = CGRect.init(x: 0, y: 100, width: 100, height: 44)
        provinceButton.centerX = view.centerX
        provinceButton.backgroundColor = .green
        view.addSubview(provinceButton)
        
        
        let cityButton: BWBaseButton = BWBaseButton.init(title: "省市", titleFont: BWSystemRegularFont(fontSize: 14), titleColor: .white)
        cityButton.tag = 10001
        cityButton.addTarget(self, action: #selector(addressShowBtn(_:)))
        cityButton.frame = CGRect.init(x: 0, y: provinceButton.maxY + 30, width: 100, height: 44)
        cityButton.centerX = view.centerX
        cityButton.backgroundColor = .red
        view.addSubview(cityButton)
        
        
        let areaButton: BWBaseButton = BWBaseButton.init(title: "省市区", titleFont: BWSystemRegularFont(fontSize: 14), titleColor: .white)
        areaButton.tag = 10002
        areaButton.addTarget(self, action: #selector(addressShowBtn(_:)))
        areaButton.frame = CGRect.init(x: 0, y: cityButton.maxY + 30, width: 100, height: 44)
        areaButton.centerX = view.centerX
        areaButton.backgroundColor = .cyan
        view.addSubview(areaButton)
    }


    @objc func addressShowBtn(_ sender: UIButton) {
        var pickerMode: BWAddressPickerMode = .area
        switch sender.tag {
        case 10000:
            pickerMode = .province
        case 10001:
            pickerMode = .city
        case 10002:
            pickerMode = .area
        default:
            pickerMode = .area
        }
//        let addressPickerView = BWAddressPickerView.init(autoSeleceted: true, mode: pickerMode, defaultRegions: ("浙江省", "湖州市", "长兴县"))
        let addressPickerView = BWAddressPickerView.init(autoSeleceted: true, mode: pickerMode, regions: ("浙江省", "湖州市", "长兴县")) { (provinceModel, cityModel, areaModel) in
            print("block回调-----省：\(provinceModel.title)----市：\(cityModel?.title)----区县：\(areaModel?.title)")
        }
//        addressPickerView.defaultRegions = ("浙江省", "湖州市", "长兴县")
        addressPickerView.delegate = self
        addressPickerView.animationShow()
    }
}

extension ViewController: BWAddressPickerViewDelegate {
    func addressPickerView(_ pickerView: BWAddressPickerView, didSelectWithProvinceModel provinceModel: BWAddressModel, cityModel: BWAddressCityModel?, areaModel: BWAddressAreaModel?) {
        print("代理回调-----省：\(provinceModel.title)----市：\(cityModel?.title)----区县：\(areaModel?.title)")
    }
    
    
}

