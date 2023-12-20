//
//  DCKYCVerifyModel.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/5.
//

import Foundation
public class DCKYCVerifyModel: DCBaseModel,DCModelConvertible {
    public typealias ClassName = DCKYCVerifyModel
    var kycId = ""
    var kycSort = 0
    var kycStatus = 0
    var kycType = 0
}

public extension DCKYCVerifyModel{
    
    static func getVerifyList(successHandler: @escaping ((_ list:[DCKYCVerifyModel])->()),
                              completionHandler:@escaping DCAlamofireManagerCompletionHandler){
        let vo = DCRequestParametersModel(bodyMap: nil, signMap: nil)
        DCAlamofireManager.shared.request(url: DCApiList.kycStatus, vo: vo) { response in
            if let responseJson = response,let kycList = responseJson["kycList"] as? [[String:Any]]{
                let list = DCKYCVerifyModel.convertModelList(with: kycList).filter { return $0.kycStatus == 0 }.sorted { $0.kycSort < $1.kycSort }
                successHandler(list)
            }else{
                successHandler([])
            }
        } failHandler: { error in
            
        } completionHandler: {
            completionHandler()
        }
    }
    
}
