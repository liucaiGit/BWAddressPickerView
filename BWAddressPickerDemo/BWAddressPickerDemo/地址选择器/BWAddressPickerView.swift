//
//  BWAddressPickerView.swift
//  CommerceSwift
//
//  Created by xiongbenwan on 2020/4/22.
//  Copyright © 2020 xiongbenwan. All rights reserved.
//

import UIKit
import SnapKit

//代理
protocol BWAddressPickerViewDelegate: NSObjectProtocol {
    func addressPickerView(_ pickerView: BWAddressPickerView, didSelectWithProvinceModel provinceModel: BWAddressModel, cityModel: BWAddressCityModel?, areaModel: BWAddressAreaModel?)
}

//闭包
typealias BWAddressPickerResultBlock = (_ provinceModel: BWAddressModel, _ cityModel: BWAddressCityModel?, _ areaModel: BWAddressAreaModel?) -> Void

/// 地址选择器高度
let BWAddressPickerViewHeight: CGFloat = 300

/// 地址选择器样式
enum BWAddressPickerMode {
    case area                    //展示省市区数据
    case province               //只展示省的数据
    case city                  //展示省市数据
}

/// 自定义地址弹出窗
class BWAddressPickerView: UIView {
    //原始数据源
    private lazy var originDataSource: [[String: Any]] = {
        if let bundlePath = Bundle.main.path(forResource: "BWAddressPicker", ofType: "bundle") {
            if let bundle = Bundle.init(path: bundlePath) {
                if let filePath = bundle.path(forResource: "areaData", ofType: "plist") {
                    if let addressDic: NSDictionary = NSDictionary(contentsOfFile: filePath) {
                        if let addressDataSource = addressDic["regions"] {
                            //                    print("----\(addressDataSource)")
                            return addressDataSource as! [[String : Any]]
                        }
                    }
                }
            }
        }
        /*
         "JSONSerialization总是报错： Error Domain=NSCocoaErrorDomain Code=3840 "JSON text did not start with array or object and option to allow fragments not set." UserInfo={NSDebugDescription=JSON text did not start with array or object and option to allow fragments not set.}
         */
        //            do {
        //                let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
        //                print("地址path---\(filePath)")
        //                let addressResultDic = try JSONSerialization.jsonObject(with: data, options: [.mutableLeaves, .mutableContainers]) as! [String: Any]
        //                if let addressDataSource = addressResultDic["regions"] {
        //                    print("----\(addressDataSource)")
        //                    return addressDataSource as! [[String : Any]]
        //                }
        //            } catch let error {
        //                print("地址信息解析错误----\(error)")
        //                return [[:]]
        //            }
        return [[:]]
    }()
    //所有省数据源---省数据一定会展示 这里使用懒加载处理
    private lazy var provinceDataSource: [BWAddressModel] = {
       return BWJsonUtil<BWAddressModel>.modelArrayFromJsonArray(originDataSource)!
    }()
    //当前省下级市数据源
//    private var cityDataSource: [BWAddressCityModel]?
    //当前市下级区数据
//    private var areaDataSource: [BWAddressAreaModel]?
    
    //当前省市区对应选中的下标
    private var selectedProvinceIndex = 0
    private var selectedCityIndex = 0
    private var selectedAreaIndex = 0
    
    //当前选中的省市区模型
    private var selectedProvinceModel: BWAddressModel?
    private var selectedCityModel: BWAddressCityModel?
    private var selectedAreaModel: BWAddressAreaModel?
    
    //地址选址器模式---默认为展示全部省市区数据
    public var pickerMode: BWAddressPickerMode = .area
    
    //默认的选中数据(省 市 区）
    public var defaultRegions: (String, String, String)? {
        didSet {
            guard let _defaultRegions = defaultRegions else {return}
            self.defaultRegions = _defaultRegions
            //配置默认选择数据
            configDefaultData()
        }
    }
    //是否自动回调选中地址
    public var shouldAutoSelect: Bool = false
    //回调闭包
    var addressSelectBlock: BWAddressPickerResultBlock?
    //代理
    weak var delegate: BWAddressPickerViewDelegate?
    
    //pickerView
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView.init()
        pickerView.backgroundColor = UIColor.white
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    //maskView
    private lazy var bgView: UIControl = {
        let view = UIControl.init(frame: UIScreen.main.bounds)
        view.backgroundColor = color666666
        view.alpha = 0
        view.isOpaque = false
        view.addTarget(self, action: #selector(cancelBtnClick(_:)))
        return view
    }()
    //cancelBtn
    private lazy var cancelBtn: BWBaseButton = {
        let button = BWBaseButton.init(title: "取消", titleFont: BWSystemRegularFont(fontSize: 14), titleColor: color333333)
        button.addTarget(self, action: #selector(cancelBtnClick(_:)))
        button.sizeToFit()
        return button
    }()
    //sureBtn
    private lazy var sureBtn: BWBaseButton = {
        let button = BWBaseButton.init(title: "确定", titleFont: BWSystemRegularFont(fontSize: 14), titleColor: color333333)
        button.addTarget(self, action: #selector(sureBtnClick(_:)))
        button.sizeToFit()
        return button
    }()
    //分割线
    private lazy var segmentLine: UIView = {
        let view = UIView.init()
        view.backgroundColor = color999999
        return view
    }()
    
    //MARK: init
    
    convenience init(selectedBlock block: BWAddressPickerResultBlock?) {
        self.init(autoSeleceted: false, selectedBlock: block)
    }
    
    convenience init(autoSeleceted isAutoSelected: Bool = false,
                     selectedBlock: BWAddressPickerResultBlock?) {
        self.init(autoSeleceted: isAutoSelected,mode: .area, regions: nil, selectedBlock: selectedBlock)
    }
    
    convenience init(autoSeleceted isAutoSelected: Bool = false,
                     mode: BWAddressPickerMode = .area,
                     defaultRegions: (String, String, String)?) {
        self.init(autoSeleceted: isAutoSelected,mode: mode, regions: defaultRegions, selectedBlock: nil)
    }
    
    convenience init(autoSeleceted isAutoSelected: Bool = false,
                     mode: BWAddressPickerMode = .area,
                     regions: (String, String, String)?,
                     selectedBlock: BWAddressPickerResultBlock?) {
        self.init()
        shouldAutoSelect = isAutoSelected
        pickerMode = mode
        self.defaultRegions = regions
        addressSelectBlock = selectedBlock
        //由于在初始化的时候不会执行didSet和willSet方法 此处手动调用设置默认选中值的方法
        if self.defaultRegions != nil {
            configDefaultData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: BWScreenHeight, width: BWScreenWidth, height: BWAddressPickerViewHeight)
        self.backgroundColor = .white
        //初始化数据
        configData()
        //initUI
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 数据配置
    
    //配置数据
    func configData() {
        selectedProvinceModel = provinceDataSource[selectedProvinceIndex]
        switch pickerMode {
        case .area:
            selectedCityModel = selectedProvinceModel?.child[selectedCityIndex]
            
            selectedAreaModel = selectedCityModel?.child[selectedAreaIndex]
        case .city:
            selectedCityModel = selectedProvinceModel?.child[selectedCityIndex]
        case .province:
            selectedProvinceModel = provinceDataSource[selectedProvinceIndex]
        }
    }
    
    //配置默认数据
    func configDefaultData() {
        //元组解包
        let (province, city, area) = defaultRegions!
        //默认选中的省数据以及下标
        for (index, provinceModel) in provinceDataSource.enumerated() {
            if provinceModel.title == province {
                selectedProvinceIndex = index
                break
            } else {
                if index == provinceDataSource.count - 1 {
                    selectedProvinceIndex = 0
                }
            }
        }
        selectedProvinceModel = provinceDataSource[selectedProvinceIndex]
        pickerView.selectRow(selectedProvinceIndex, inComponent: 0, animated: true)

        if pickerMode == .city || pickerMode == .area {
            if selectedProvinceModel?.child.count ?? 0 > 0 {
                for (index, cityModel) in (selectedProvinceModel?.child.enumerated())! {
                    if cityModel.title == city {
                        selectedCityIndex = index
                        break
                    } else {
                        if index == (selectedProvinceModel?.child.count)! - 1 {
                            selectedCityIndex = 0
                        }
                    }
                }
                selectedCityModel = selectedProvinceModel?.child[selectedCityIndex]
                pickerView.selectRow(selectedCityIndex, inComponent: 1, animated: true)
            }
        }
        if pickerMode == .area {
            if selectedCityModel?.child.count ?? 0 > 0 {
                for (index, areaModel) in (selectedCityModel?.child.enumerated())! {
                    if areaModel.title == area {
                        selectedAreaIndex = index
                        break
                    } else {
                        if index == selectedCityModel?.child.count ?? 0 - 1 {
                            selectedAreaIndex = 0
                        }
                    }
                }
                selectedAreaModel = selectedCityModel?.child[selectedAreaIndex]
                pickerView.selectRow(selectedAreaIndex, inComponent: 2, animated: true)
            }
        }
        pickerView.reloadAllComponents()
    }
    
    //MARK: UI
    
    //initUI
    func initUI() {
        //initPickerView
        initPickerView()
        
        addSubview(cancelBtn)
        addSubview(sureBtn)
        addSubview(segmentLine)
    }
    
    func initPickerView() {
        addSubview(pickerView)
        pickerView.reloadAllComponents()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview()
            make.height.equalTo(44)
        }
        sureBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview()
            make.height.equalTo(44)
        }
        segmentLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(cancelBtn.snp_bottom)
            make.height.equalTo(0.4)
        }
        pickerView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentLine.snp_bottom)
            make.bottom.equalToSuperview().offset(-BWTabBarBottomHeight)
            make.left.right.equalToSuperview()
        }
    }
    
    //MARK: 按钮点击响应
    
    @objc func cancelBtnClick(_ sender: UIButton) {
        animationHidden()
    }
    
    @objc func sureBtnClick(_ sender: UIButton) {
        animationHidden()
        //不自动回调情况下传出选中地址数据
        if shouldAutoSelect == false {
            selectedAddress()
        }
    }
    
    func selectedAddress() {
        //block回调
        self.addressSelectBlock?(selectedProvinceModel!,selectedCityModel,selectedAreaModel)
        //代理回调
        self.delegate?.addressPickerView(self, didSelectWithProvinceModel: selectedProvinceModel!, cityModel: selectedCityModel, areaModel: selectedAreaModel)
    }
}

//MARK: Show & Hidden

extension BWAddressPickerView {
    func animationShow() {
        UIApplication.shared.keyWindow?.addSubview(bgView)
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0.8
            self.y = BWScreenHeight - BWAddressPickerViewHeight
        }
    }
    
    func animationHidden() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.alpha = 0
            self.y = BWScreenHeight
        }) { (completed) in
            self.bgView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
}

//MARK: UIPickerViewDataSource

extension BWAddressPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerMode {
        case .area:
            return 3
        case .city:
            return 2
        case .province:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return provinceDataSource.count
        case 1:
            return selectedProvinceModel?.child.count ?? 0
        case 2:
            return selectedCityModel?.child.count ?? 0
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return BWScreenScaleWidth(width: 35)
    }
}

//MARK: UIPickerViewDelegate

extension BWAddressPickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        //设置分割线颜色
        for subView in pickerView.subviews {
            if subView.isKind(of: UIView.self) && subView.height <= 1 {
                subView.backgroundColor = BWHexColor("#EAEAEA")
            }
        }
        var label = view as? UILabel
        if label == nil {
            label = UILabel.init()
            label?.font = BWSystemRegularFont(fontSize: 14)
            label?.textColor = color333333
            label?.textAlignment = .center
            label?.minimumScaleFactor = 0.5
            label?.adjustsFontSizeToFitWidth = true
        }
        switch component {
        case 0:
            //省标题
            let provinceModel = provinceDataSource[row]
            label?.text = provinceModel.title
        case 1:
            let cityModel = selectedProvinceModel?.child[row]
            label?.text = cityModel?.title
        case 2:
            let areaModel = selectedCityModel?.child[row]
            label?.text = areaModel?.title
        default:
            break
        }
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedProvinceIndex = row
            selectedProvinceModel = provinceDataSource[row]
            switch pickerMode {
            case .province:
                selectedCityModel = nil
                selectedAreaModel = nil
            case .city:
                selectedCityIndex = 0
                //避免港澳台地区没有下级市的情况
                if selectedProvinceModel?.child.count ?? 0 > 0 {
                    selectedCityModel = selectedProvinceModel?.child[selectedCityIndex]
                    pickerView.selectRow(selectedCityIndex, inComponent: 1, animated: true) 
                } else {
                    selectedCityModel = nil
                }
                selectedAreaModel = nil
                //刷新下级市数据
                pickerView.reloadComponent(1)
            case .area:
                //刷新下级市以及下级县数据
                selectedCityIndex = 0
                if selectedProvinceModel?.child.count ?? 0 > 0 {
                    selectedCityModel = selectedProvinceModel?.child[selectedCityIndex]
                    selectedAreaIndex = 0
                    pickerView.selectRow(selectedCityIndex, inComponent: 1, animated: true)
                    if selectedCityModel?.child.count ?? 0 > 0 {
                        selectedAreaModel = selectedCityModel?.child[selectedAreaIndex]
                        pickerView.selectRow(selectedAreaIndex, inComponent: 2, animated: true)
                    } else {
                        selectedAreaModel = nil;
                    }
                } else {
                    selectedCityModel = nil
                    selectedAreaModel = nil;
                }
                pickerView.reloadComponent(1)
                pickerView.reloadComponent(2)
            }
        case 1:
            selectedCityIndex = row
            selectedCityModel = selectedProvinceModel?.child[row]
            switch pickerMode {
            case .city:
                selectedAreaModel = nil
            case .area:
                selectedAreaIndex = 0
                //避免某些下级市没有更下级的县区造成的数组越界问题
                if selectedCityModel?.child.count ?? 0 > 0 {
                    selectedAreaModel = selectedCityModel?.child[selectedAreaIndex]
                    pickerView.selectRow(selectedAreaIndex, inComponent: 2, animated: true)
                } else {
                    selectedAreaModel = nil
                }
                pickerView.reloadComponent(2)
            default:
                break
            }
        case 2:
            selectedAreaIndex = row
            selectedAreaModel = selectedCityModel?.child[selectedAreaIndex]
        default:
            break
        }
        if shouldAutoSelect == true {
            selectedAddress()
        }
    }
}
