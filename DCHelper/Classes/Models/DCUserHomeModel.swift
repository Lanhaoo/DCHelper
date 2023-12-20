//
//  DCUserHomeModel.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/7.
//

import Foundation
public enum DCUserHomeStatus: Int {
    case unowned = 0
    case pendingVerification = 10
    case pendingLoanApplication = 20
    case waitingForData = 30
    case pendingWithdrawal = 32
    case modifyingBankCard = 41
    case underReview = 50
    case rejected = 51
    case loanInProgress = 70
    case pendingRepayment = 80
    case overdue = 81
}

public class DCUserHomeModel: DCBaseModel,DCModelConvertible {
    public typealias ClassName = DCUserHomeModel
    var userStatus = 0
    var promptCopy = ""
    var hasOrder = 0
    var firstLoanOptionLine = ""
    var downloadUrl = ""
    var appUserType = 0
    var loanSuccessRecordList = [String]()
    var appProductBanner = [DCAppLabelBannerModel]()
    
    var isSystemCreateOrder:Bool{
        get{
            return firstLoanOptionLine == "system" && hasOrder == 0
        }
    }
}

public class DCAppLabelBannerModel:DCBaseModel{
    var bannerHref = ""
    var relationId = ""
}

public extension DCUserHomeModel{
    
    static func load(successHandler: @escaping((DCUserHomeModel)->()),
                     failHandler:DCAlamofireManagerFailHandler? = nil,
                     completionHandler:DCAlamofireManagerCompletionHandler? = nil){
        
        let vo = DCRequestParametersModel(bodyMap: nil, signMap: nil)
        
        DCAlamofireManager.shared.request(url: DCApiList.userSuphome, vo: vo) { response in
            if let userSuphomeJson = response,let model = DCUserHomeModel.convertModel(with: userSuphomeJson){
                successHandler(model)
            }else{
                successHandler(DCUserHomeModel())
            }
        } failHandler: { error in
            
        } completionHandler: {
            completionHandler?()
        }
    }
    
}
