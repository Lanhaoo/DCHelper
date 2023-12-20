//
//  DCAlamofireManagerResponseModel.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/11/29.
//

import Foundation

public class DCResponseModel: DCBaseModel,DCModelConvertible {
    public typealias ClassName = DCResponseModel
    var resultCode = 0
    var resultMsg = ""
    var data:[String: Any]?
    required init() {}
}
extension DCResponseModel{
    
    convenience init(resultCode:Int,resultMsg:String) {
        self.init()
        self.resultCode = resultCode
        self.resultMsg = resultMsg
    }
    
}
