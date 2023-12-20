// 
//  parameters.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/11/30.
//

import Foundation

public class DCRequestParametersModel: DCBaseModel {
    required init() {}
    let appId = DCAppConfigManager.shared.appId
    let channel = "app_store"
    let clientLanguage = "es"
    let userId = DCUserDefaultsHelper.getUserId()
    let token = DCUserDefaultsHelper.getUserToken()
    let os = "2"
    let version = "2.0"
    let clientTime = StringProcessing.generateNowTimeInterval()
    let clientVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    var sign = ""
    var nonce = ""
    var deviceId = DCDeviceToolHelper.deviceId
    var data = [String:Any]()
}
public extension DCRequestParametersModel{
    
    convenience init(bodyMap:[String:Any]?,signMap:[String:Any]?) {
        self.init()
        self.nonce = StringProcessing.generateRandomString()
        if let dataMap = bodyMap {
            self.data = dataMap
        }
        self.sign = createSignString(data: signMap)
    }
    
    func createSignString(data: [String: Any]?) -> String {
        var unsortedMap: [String: Any] = [
            "appId": self.appId,
            "deviceId": self.deviceId,
            "os": self.os,
            "channel": self.channel,
            "version": self.version,
            "clientTime": self.clientTime,
            "nonce": self.nonce
        ]
        if let dict = data {
            for (key, value) in dict {
                unsortedMap[key] = value
            }
        }
        let sortedMap = unsortedMap.sorted { $0.key < $1.key }
        let mapArray = sortedMap.map { key, value in
            return "\(key)=\(value)"
        }
        let newStr = mapArray.joined(separator: "&")
        let s2 = StringProcessing.md5Hash(text: newStr).uppercased()
        let s3 = s2 + DCAppConfigManager.shared.appSalt
        return StringProcessing.md5Hash(text: s3).uppercased()
    }
}
