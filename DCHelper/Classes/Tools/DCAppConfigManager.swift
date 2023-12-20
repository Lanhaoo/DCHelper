//
//  DCAppConfigManager.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/20.
//

import Foundation

public final class DCAppConfigManager{
    
    public static let shared = DCAppConfigManager()
    
    public var appConfigModel:DCAppConfigModel?
    
    public var requireLocationAndContactsPermission:Bool{
        get{
            guard let appConfigModel = self.appConfigModel else { return true }
            return appConfigModel.requireLocationAndContactsPermission
        }
    }
    
    public var URLDomain = ""
    
    public var appId = ""
    
    public var appSalt = ""
    
    public var appToken = ""
    
    public var register = ""
    
    public var liveness = ""
    
    public var info = ""
    
    public var job = ""
    
    public var contact = ""
    
    public var account = ""
    
    public var curp = ""
    
    public var apply = ""
    
    public var cameraAlertMessage = ""
    
    public var contactStoreAlertMessage = ""
    
    public var locationAlertMessage = ""
}

public extension DCAppConfigManager{
    
    func getAppConfigData(completionHandler:((_ vo:DCAppConfigModel)->())? = nil){
        guard let appConfigModel = self.appConfigModel else {
            DCAppConfigModel.loadData { vo in
                self.appConfigModel = vo
                completionHandler?(vo)
            }
            return
        }
        completionHandler?(appConfigModel)
    }
    
}
