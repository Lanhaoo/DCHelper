//
//  DCAdjustHelper.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/5.
//

import UIKit
import Adjust

public final class DCAdjustHelper: NSObject {
    
    public static let shared = DCAdjustHelper()
    
    public func appDidLaunch(isProduction:Bool){
        let yourAppToken = DCAppConfigManager.shared.appToken
        let environment = isProduction ? ADJEnvironmentProduction : ADJEnvironmentSandbox
        let adjustConfig = ADJConfig(
            appToken: yourAppToken,
            environment: environment)
        Adjust.appDidLaunch(adjustConfig)
    }
    
    public func getAdid()->String?{
        return Adjust.adid()
    }
    
    public func addRegisterEvent(){
        add(eventToken: DCAppConfigManager.shared.register)
    }

    public func addLivenessEvent(){
        add(eventToken: DCAppConfigManager.shared.liveness)
    }
    
    public func addInfoEvent(){
        add(eventToken: DCAppConfigManager.shared.info)
    }
    
    public func addJobEvent(){
        add(eventToken: DCAppConfigManager.shared.job)
    }
    
    public func addContactEvent(){
        add(eventToken: DCAppConfigManager.shared.contact)
    }
    
    public func addAccountEvent(){
        add(eventToken: DCAppConfigManager.shared.account)
    }
    
    public func addCurpEvent(){
        add(eventToken: DCAppConfigManager.shared.curp)
    }
    
    public func addApplyEvent(){
        add(eventToken: DCAppConfigManager.shared.apply)
    }
}

extension DCAdjustHelper{
    
    private func add(eventToken:String){
        if let adid = getAdid(),adid.count > 0 {
            let event = ADJEvent(eventToken: eventToken)
            Adjust.trackEvent(event)
        }else{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                self.add(eventToken: eventToken)
            })
        }
    }
    
}

