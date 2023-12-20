//
//  DCUserModel.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/7.
//

import Foundation
public class DCUserModel: DCBaseModel,DCModelConvertible {
    public typealias ClassName = DCUserModel
    var userStatus = 0
    var appUserType = 0
    var phone = ""
    var name = ""
    var payAccountModifySwitch = ""
    var isAllowModifyPayAccount:Bool {
        get{
            return payAccountModifySwitch == "on"
        }
    }
}
public extension DCUserModel{
    
    static func load(_ adid:String? = nil,
                    successHandler: ((DCUserModel)->())? = nil,
                    failHandler:DCAlamofireManagerFailHandler? = nil,
                    completionHandler:DCAlamofireManagerCompletionHandler? = nil){
        
        var vo:DCRequestParametersModel?
        
        if let adid = adid {
            
            let dataMap: [String: Any] = ["adid": adid]
            
            vo = DCRequestParametersModel(bodyMap: dataMap, signMap: nil)
            
        }else{
            vo = DCRequestParametersModel(bodyMap: nil, signMap: nil)
            
        }
        DCAlamofireManager.shared.request(url: DCApiList.userInfo, vo: vo!) { response in
            if let userInfoJson = response,let model = DCUserModel.convertModel(with: userInfoJson){
                successHandler?(model)
            }else{
                successHandler?(DCUserModel())
            }
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler?()
        }
    }
}
