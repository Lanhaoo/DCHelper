//
//  DCOrderHelper.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/7.
//

import Foundation
public final class DCOrderHelper: NSObject {
    
    public static let shared = DCOrderHelper()
    
    public func getLoanProduct(productId:String,
                        successHandler: @escaping((DCLoanProductModel)->()),
                        failHandler:DCAlamofireManagerFailHandler? = nil,
                        completionHandler:DCAlamofireManagerCompletionHandler? = nil){
        let dataMap = ["productId":productId] as! [String : Any]
        let vo = DCRequestParametersModel(bodyMap: dataMap, signMap: dataMap)
        DCAlamofireManager.shared.request(url: DCApiList.productTerm, vo: vo) { response in
            if let productTermJson = response,let model = DCLoanProductModel.convertModel(with: productTermJson){
                successHandler(model)
            }else{
                successHandler(DCLoanProductModel())
            }
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler?()
        }
    }
    
    public func getReadyForWithdrawalProduct(orderId:String,
                                      successHandler:@escaping((DCLoanProductModel)->()),
                                      failHandler:DCAlamofireManagerFailHandler? = nil,
                                      completionHandler:DCAlamofireManagerCompletionHandler? = nil){
        let dataMap = ["orderId":orderId] as! [String : Any]
        let vo = DCRequestParametersModel(bodyMap: dataMap, signMap: dataMap)
        DCAlamofireManager.shared.request(url: DCApiList.orderWithdrawnDetail, vo: vo) { response in
            if let json = response,let vo = DCLoanProductModel.convertModel(with: json){
                successHandler(vo)
            }
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler?()
        }
    }
    
    
    public func initOrder(productId:String,
                   loanAmount:String,
                   loanTerm:String,
                   bindId:String,
                   latitude:String,
                   longitude:String,
                   successHandler:@escaping((String)->()),
                   failHandler:DCAlamofireManagerFailHandler? = nil,
                   completionHandler:DCAlamofireManagerCompletionHandler? = nil){
        let dataMap = ["productId":productId,
                       "latitude":latitude,
                       "longitude":longitude,
                       "bankCardBindId":bindId,
                       "loanAmount":loanAmount,
                       "imei":"null",
                       "serialNo":DCDeviceToolHelper.deviceId,
                       "loanTerm":loanTerm]
        let signMap = ["productId":productId,
                       "latitude":latitude,
                       "longitude":longitude,
                       "bankCardBindId":bindId,
                       "loanAmount":loanAmount,
                       "imei":"null",
                       "serialNo":DCDeviceToolHelper.deviceId]
        let vo = DCRequestParametersModel(bodyMap: dataMap, signMap: signMap)
        DCAlamofireManager.shared.request(url: DCApiList.orderSubmit, vo: vo) { response in
            if let dict = response,let isFirst = dict["isFirst"] as? Int,let orderId = dict["orderId"] as? String{
                if isFirst == 1{
                    DCAdjustHelper.shared.addApplyEvent()
                }
                successHandler(orderId)
            }
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler?()
        }
    }
    
    public func orderReadyRequiredUserContactStore(orderId:String,
                                            successHandler:@escaping(()->()),
                                            failHandler:DCAlamofireManagerFailHandler? = nil,
                                            completionHandler:DCAlamofireManagerCompletionHandler? = nil){
        let dataMap = ["orderId":orderId] as! [String : Any]
        let vo = DCRequestParametersModel(bodyMap: dataMap, signMap: dataMap)
        DCAlamofireManager.shared.request(url: DCApiList.orderReady, vo: vo) { response in
            successHandler()
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler?()
        }
    }
    
    public func orderReadyUnRequiredUserContactStore(orderId:String,
                                              successHandler:@escaping(()->()),
                                              failHandler:DCAlamofireManagerFailHandler? = nil,
                                              completionHandler:DCAlamofireManagerCompletionHandler? = nil){
        let dataMap = ["orderId":orderId,"allowContact":"2"] as! [String : Any]
        let signMap = ["orderId": orderId] as [String: Any]
        let vo = DCRequestParametersModel(bodyMap: dataMap, signMap: signMap)
        DCAlamofireManager.shared.request(url: DCApiList.orderReady, vo: vo) { response in
            successHandler()
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler?()
        }
    }
    
    public func uploadUserContact(orderId: String,
                           batchList: [[NSDictionary]],
                           completion: @escaping () -> Void) {
        if batchList.isEmpty {
            completion()
            return
        }
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "DC_SEND_ContactStore_QUEUE", attributes: .concurrent)
        for data in batchList {
            queue.async(group: group) {
                group.enter()
                self.uploadContact(orderId: orderId, list: data) {
                    group.leave()
                } failHandler: { model in
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            completion()
        }
    }
    
    private func uploadContact(orderId: String,
                               list:[NSDictionary],
                               successHandler:@escaping(()->()),
                               failHandler:DCAlamofireManagerFailHandler? = nil) {
        let dataMap = ["orderId": orderId, "list": list] as [String: Any]
        let signMap = ["orderId": orderId]
        let vo = DCRequestParametersModel(bodyMap: dataMap, signMap: signMap)
        DCAlamofireManager.shared.request(url: DCApiList.mobileContact, vo: vo) { response in
            successHandler()
        } failHandler: { error in
            failHandler?(error)
        }
    }
    
    
    public func getOrderList(orderStatus:Int,
                      successHandler:@escaping ([DCOrderItemModel]) -> Void,
                      failHandler:DCAlamofireManagerFailHandler? = nil,
                      completionHandler:DCAlamofireManagerCompletionHandler? = nil){
        let dataMap = ["orderStatus": orderStatus]
        let vo = DCRequestParametersModel(bodyMap: dataMap, signMap: nil)
        DCAlamofireManager.shared.request(url: DCApiList.orderList, vo: vo) { response in
            if let json = response,let orderList = json["orderList"] as? [[String: Any]] {
                successHandler(DCOrderItemModel.convertModelList(with:orderList))
            }else{
                successHandler([])
            }
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler?()
        }
    }
    
    
    public func getOrderDetail(orderId:String,
                        successHandler: @escaping((orderVO:DCOrderItemModel,bankCardVO:DCUserBankCardModel?,productVO:DCProductModel)) -> Void,
                        failHandler:DCAlamofireManagerFailHandler? = nil,
                        completionHandler:DCAlamofireManagerCompletionHandler? = nil){
        let dataMap = ["orderId": orderId,"appType":"DC"]
        let vo = DCRequestParametersModel(bodyMap: dataMap, signMap: ["orderId": orderId])
        DCAlamofireManager.shared.request(url: DCApiList.orderDetail, vo: vo) { response in
            if let json = response{
                if let orderDetail = json["orderDetail"] as? [String: Any],
                   let product = json["product"] as? [String: Any],
                   let orderVO = DCOrderItemModel.convertModel(with: orderDetail),
                   let productVO = DCProductModel.convertModel(with: product) {
                    if let bankCard = json["bankCard"] as? [String: Any],let cardVO = DCUserBankCardModel.convertModel(with: bankCard){
                        successHandler((orderVO,cardVO,productVO))
                    }else{
                        successHandler((orderVO,nil,productVO))
                    }
                }
            }
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler?()
        }
    }
    
    
    public func orderWithdrawal(orderId:String,
                         loanAmount:String,
                         loanTerm:String,
                         successHandler:@escaping(()->()),
                         failHandler:DCAlamofireManagerFailHandler? = nil,
                         completionHandler:DCAlamofireManagerCompletionHandler? = nil){
        let dataMap = ["orderId":orderId,"loanAmount":loanAmount,"loanTerm":loanTerm] as! [String : Any]
        let vo = DCRequestParametersModel(bodyMap: dataMap, signMap: ["orderId":orderId] as? [String : Any])
        DCAlamofireManager.shared.request(url: DCApiList.applyWithdrawal, vo: vo) { response in
            successHandler()
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler?()
        }
    }
    
    public func orderRefund(orderId:String,
                     repayType:Int,
                     successHandler: @escaping((String)->()),
                     failHandler:DCAlamofireManagerFailHandler? = nil,
                     completionHandler:DCAlamofireManagerCompletionHandler? = nil){
        let dataMap = ["orderId":orderId,"periodNoList":[1]] as [String : Any]
        let signMap = ["orderId":orderId]
        let vo = DCRequestParametersModel(bodyMap: dataMap, signMap: signMap)
        DCAlamofireManager.shared.request(url: repayType == 0 ? DCApiList.repayConnect : DCApiList.repayExtension, vo: vo) { response in
            if let dict = response,let url = dict["connect"] as? String{
                successHandler(url)
            }
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler?()
        }
    }
    
}
