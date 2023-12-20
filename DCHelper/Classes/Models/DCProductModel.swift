//
//  DCProductModel.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/7.
//

import Foundation
public class DCProductModel: DCBaseModel,DCModelConvertible{
    
    public typealias ClassName = DCProductModel
    
    var productLogo = ""
    
    var productId = ""
    
    var productName = ""
    
    var productLabel = ""
    
    var lowAmount = ""
    
    var highAmount = ""
    
    var lowestLoanInterestRate = ""
    
    var productApplicantsNumber = ""
    
}

public extension DCProductModel{
    
    static func load(successHandler: @escaping(([DCProductModel])->()),
                     failHandler:DCAlamofireManagerFailHandler? = nil,
                     completionHandler:DCAlamofireManagerCompletionHandler? = nil){
        let vo = DCRequestParametersModel(bodyMap: nil, signMap: nil)
        DCAlamofireManager.shared.request(url: DCApiList.productList, vo: vo) { response in
            if let responseJson = response,let productInfoList = responseJson["productInfoList"] as? [[String:Any]]{
                successHandler(DCProductModel.convertModelList(with: productInfoList))
            }else{
                successHandler([])
            }
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler?()
        }
    }
    
}
