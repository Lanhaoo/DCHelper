//
//  DCKYCItemModel.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/6.
//

import Foundation
import UIKit
public enum DCKYCItemInput:String {
    case tax_card_no
    case child_count
    case whatsapp
    case company_contact_phone
    case account_no
    case address
    case email
}
public enum DCKYCItemUserAction:Int {
    case input = 1
    case buttonList = 3
    case dictionary = 4
}
public enum DCKYCItemDictionary:String {
    case province
    case city
    case bank_code
}
public enum DCUserBankCardType:String{
    case clabe
    case debit_card
    var maximumInputLength:Int{
        get{
            switch self {
            case .clabe:
                return 18
            case .debit_card:
                return 16
            }
        }
    }
}
public class DCKYCItemModel: DCBaseModel,DCModelConvertible {
    public typealias ClassName = DCKYCItemModel
    var itemName = ""
    var regularExpression = ""
    var itemCode = ""
    var itemSort = 0
    private var itemType = 0
    private var isRequired = 0
    private var buttonList = [DCKYCButtonItemModel]()
    
    var isNotEmpty:Bool { get { return isRequired == 1 } }
    var key = ""
    var value = ""
    
    var sortedList:[DCKYCButtonItemModel]{
        get{
            let list = buttonList.sorted {
                return $0.buttonSort < $1.buttonSort
            }
            return list
        }
    }
    
    var textList:[String]{
        get{
            var textArr = [String]()
            for item in sortedList{
                textArr.append(item.buttonLabel)
            }
            return textArr
        }
    }
    
    
    var itemUserActionType:DCKYCItemUserAction{
        get{
            if let action = DCKYCItemUserAction(rawValue: itemType){
                return action
            }
            return .input
        }
    }
    
    private var _maximumInputLength = 16
    private var _keyboardType = UIKeyboardType.default
    var keyboardInfo:(maximumInputLength:Int,keyboardType:UIKeyboardType){
        set(newValue) {
            _maximumInputLength = newValue.maximumInputLength
            _keyboardType = newValue.keyboardType
        }
        get{
            if let type = DCKYCItemInput.init(rawValue: itemCode) {
                switch type {
                case .tax_card_no:
                    _maximumInputLength = 13
                    _keyboardType = UIKeyboardType.default
                case .child_count:
                    _maximumInputLength = 3
                    _keyboardType = .numberPad
                case .whatsapp:
                    _maximumInputLength = 10
                    _keyboardType = .numberPad
                case .company_contact_phone:
                    _maximumInputLength = 12
                    _keyboardType = .numberPad
                case .account_no:
                    _keyboardType = .numberPad
                case .address:
                    _maximumInputLength = 32
                    _keyboardType = UIKeyboardType.default
                case .email:
                    _maximumInputLength = 100
                    _keyboardType = UIKeyboardType.default
                }
                return (_maximumInputLength,_keyboardType)
            }
            return (_maximumInputLength,_keyboardType)
        }
    }
}

public class DCKYCButtonItemModel: DCBaseModel {
    var buttonKey = ""
    var buttonLabel = ""
    var buttonSort = 0
}


public extension DCKYCItemModel{
    
    static func initData(kycId:String,
                         successHandler:@escaping(([DCKYCItemModel])->()),
                         failHandler:DCAlamofireManagerFailHandler? = nil,
                         completionHandler:@escaping(()->())){
        let dataMap: [String: Any] = ["kycId": kycId]
        let vo = DCRequestParametersModel(bodyMap: dataMap, signMap: dataMap)
        DCAlamofireManager.shared.request(url: DCApiList.kycInit, vo: vo) { response in
            if let dict = response,let list = dict["kycItemList"] as? [[String:Any]]{
                let unsortlist = DCKYCItemModel.convertModelList(with: list)
                successHandler(unsortlist.sorted{ $0.itemSort < $1.itemSort })
            }else{
                successHandler([])
            }
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler()
        }
    }
    
    static func doCommit(kycId:String,
                         parametersList:[[String:Any]],
                         successHandler:@escaping(()->()),
                         failHandler:DCAlamofireManagerFailHandler? = nil,
                         completionHandler:@escaping(()->())){
        let dataMap = ["kycId":kycId,"kycCommitItemList":parametersList] as [String : Any]
        let vo = DCRequestParametersModel(bodyMap: dataMap, signMap: ["kycId":kycId])
        DCAlamofireManager.shared.request(url: DCApiList.kycCommit, vo: vo) { response in
            successHandler()
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler()
        }
    }
}
