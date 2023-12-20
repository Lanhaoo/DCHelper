//
//  DCUserDefaultsHelper.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/11/30.
//

import Foundation
public enum DCUserDefaultsKey:String{
    case userId
    case userToken
    case firstOpenApp
    case isShowLaunch
}
public struct DCUserDefaultsHelper {
    
    public static let shared = UserDefaults.standard
    
    public static func setUserId(_ userId:String){
        shared.setValue(userId, forKey: DCUserDefaultsKey.userId.rawValue)
        shared.synchronize()
    }
    
    public static func getUserId()->String{
        return shared.string(forKey: DCUserDefaultsKey.userId.rawValue) ?? ""
    }
    
    public static func setUserToken(_ userToken:String){
        shared.setValue(userToken, forKey: DCUserDefaultsKey.userToken.rawValue)
        shared.synchronize()
    }
    
    public static func getUserToken()->String{
        return shared.string(forKey: DCUserDefaultsKey.userToken.rawValue) ?? ""
    }
    
    public static func clearUserInfo(){
        shared.removeObject(forKey: DCUserDefaultsKey.userId.rawValue)
        shared.removeObject(forKey: DCUserDefaultsKey.userToken.rawValue)
    }
    
    public static func firstOpenApp()->Bool{
        if let result = shared.value(forKey: DCUserDefaultsKey.firstOpenApp.rawValue) as? Bool {
            return result
        }
        return true
    }
    
    public static func setAppOpened(){
        shared.setValue(false, forKey: DCUserDefaultsKey.firstOpenApp.rawValue)
    }
    
    
    public static func isShowLaunch()->Bool{
        if let result = shared.value(forKey: DCUserDefaultsKey.isShowLaunch.rawValue) as? Bool {
            return result
        }
        return false
    }
    
    public static func setShowLaunch(){
        shared.setValue(true, forKey: DCUserDefaultsKey.isShowLaunch.rawValue)
    }
    
    
}
