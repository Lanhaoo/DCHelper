//
//  DCDeviceToolHelper.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/19.
//

import Foundation
import FCUUID

public struct DCDeviceToolHelper {

    public static var deviceId:String{
        get{
            return FCUUID.uuidForDevice()
        }
    }
    
    public static func getUserContactBookData(with maxCount:Int)->[[String:Any]]{
        if let list = DCDeviceTool.getContactBookData(withMaxCount: maxCount) as? [[String:Any]] {
            return list
        }
        return [[String:Any]]()
    }
    
    public static var deviceInfo:[String:Any]{
        get{
            if let dict = DCDeviceTool.getAllData() as? [String:Any] {
                return dict
            }
            return [String:Any]()
        }
    }
    
    public static func uploadDeviceInfoOnRegister(){
        let vo = DCRequestParametersModel(bodyMap: deviceInfo, signMap: nil)
        DCAlamofireManager.shared.request(url: DCApiList.registerDevice, vo: vo)
    }
    
    public static func uploadDeviceInfoOnWaitingForSubmitData(orderId: String,
                                                       successHandler: @escaping () -> Void,
                                                       failHandler: @escaping DCAlamofireManagerFailHandler) {
        var deviceInfo = self.deviceInfo
        deviceInfo["orderId"] = orderId
        let signMap = ["orderId": orderId] as [String: Any]
        let vo = DCRequestParametersModel(bodyMap: deviceInfo, signMap: signMap)
        DCAlamofireManager.shared.request(url: DCApiList.mobileDevice, vo: vo) { _ in
            successHandler()
        } failHandler: { error in
            failHandler(error)
        }
    }
    
    public static func getContactBookList(completionHandler:@escaping(([[[String:Any]]])->())){
        DCAppConfigManager.shared.getAppConfigData { vo in
            DispatchQueue.global(qos: .userInteractive).async {
                let list = self.getUserContactBookData(with: vo.pushMaxCount)
                DispatchQueue.main.async {
                    completionHandler(list.splitLength(length: vo.pushPerCount))
                }
            }
        }
    }
}
