//
//  DCUserBankCardModel.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/7.
//

import Foundation
public class DCUserBankCardModel: DCBaseModel,DCModelConvertible {
    public typealias ClassName = DCUserBankCardModel
    var bankCode = ""
    var accountName = ""
    var accountType = ""
    var bankName = ""
    var bindId = ""
    var accountPhone = ""
    var accountNo = ""
    var currency = ""
}
 
public extension DCUserBankCardModel{
    
    static func modifyUserBankCard(accountType:String,
                                   bankCode:String,
                                   accountNo:String,
                                   successHandler: @escaping () -> Void,
                                   failHandler:DCAlamofireManagerFailHandler? = nil,
                                   completionHandler:@escaping DCAlamofireManagerCompletionHandler){
        let dataMap = ["accountType":accountType,"bankCode":bankCode,"accountNo":accountNo]
        let vo = DCRequestParametersModel(bodyMap: dataMap, signMap: dataMap)
        DCAlamofireManager.shared.request(url: DCApiList.bankcardModify, vo: vo) { response in
            successHandler()
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler()
        }
    }
    
    static func getUserBankCard(successHandler: @escaping((DCUserBankCardModel)->()),
                                  failHandler:DCAlamofireManagerFailHandler? = nil,
                                  completionHandler:DCAlamofireManagerCompletionHandler? = nil){
        let vo = DCRequestParametersModel(bodyMap: nil, signMap: nil)
        DCAlamofireManager.shared.request(url: DCApiList.bankcardList, vo: vo) { response in
            if let responseJson = response,let bankCardList = responseJson["bankCardList"] as? [[String:Any]],bankCardList.count > 0{
                successHandler(DCUserBankCardModel.convertModel(with: bankCardList[0])!)
            }
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler?()
        }
    }
}
