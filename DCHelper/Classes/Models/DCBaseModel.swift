//
//  DCBaseModel.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/11/29.
//

import Foundation
import HandyJSON
open class DCBaseModel: HandyJSON {
    required public init() {}
}


public protocol DCModelConvertible {
    
    associatedtype ClassName:DCBaseModel
    
    static func convertModel(with json: [String:Any]?) -> ClassName?
    
    static func convertModelList(with json: [[String:Any]]) -> [ClassName]
    
}
public extension DCModelConvertible{
    
    static func convertModel(with json: [String:Any]?) -> ClassName?{
        if let dict = json,let VO = ClassName.deserialize(from: dict) {
            return VO
        }
        return nil
    }
    
    static func convertModelList(with json: [[String:Any]]) -> [ClassName]{
        var result = [ClassName]()
        json.forEach { item in
            if let VO = ClassName.deserialize(from: item) {
                result.append(VO)
            }
        }
        return result
    }
    
}
