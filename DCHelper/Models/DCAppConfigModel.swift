//
//  DCAppConfigModel.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/4.
//

import UIKit
public class DCAppConfigModel: DCBaseModel,DCModelConvertible {
    public typealias ClassName = DCAppConfigModel
    var contactHref:String = ""
    var pushPerCount:Int = 0
    var policyHref:String = ""
    var pushMaxCount:Int = 0
    var conditionsHref:String = ""
    var retrieveMobileContact = 0
    var requireLocationAndContactsPermission:Bool { get { return retrieveMobileContact == 1 } }
}

public extension DCAppConfigModel{
    
    static func loadData(completionHandler:((_ vo:DCAppConfigModel)->())? = nil){
        let vo = DCRequestParametersModel(bodyMap: nil, signMap: nil)
        DCAlamofireManager.shared.request(url: DCApiList.appConfig, vo: vo) { response in
            if let responseJson = response ,let model = DCAppConfigModel.convertModel(with: responseJson){
                completionHandler?(model)
            }
        } failHandler: { error in
            
            
        } completionHandler: {
            DCToastHelper.shared.hide()
        }
    }
    
}
