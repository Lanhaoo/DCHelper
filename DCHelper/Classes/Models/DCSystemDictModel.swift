//
//  DCSystemDictModel.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/6.
//

import Foundation
public class DCSystemDictModel: DCBaseModel,DCModelConvertible{
    public typealias ClassName = DCSystemDictModel
    var label = ""
    var key = ""
    var sort = 0
    var isSelected = false
    
    static func extractLabels(from systemDicts: [DCSystemDictModel]) -> [String] {
        return systemDicts.map { $0.label }
    }
}


public extension DCSystemDictModel{
    
    typealias SystemDictModelLoadSuccessHandler = ([DCSystemDictModel]) -> Void
    
    
    private static func dealResult(dictionaryList:[[String: Any]],
                           onSuccess: @escaping SystemDictModelLoadSuccessHandler) {
        
        var resultList = [DCSystemDictModel]()
        
        resultList = DCSystemDictModel.convertModelList(with: dictionaryList)
        
        onSuccess(resultList.sorted { $0.sort < $1.sort })
        
    }
    
    
    
    static func getProvinces(successHandler:@escaping SystemDictModelLoadSuccessHandler,
                             failHandler:DCAlamofireManagerFailHandler? = nil,
                             completionHandler:@escaping(()->())){
        let dataMap = ["countryId": 52]
        let vo = DCRequestParametersModel.init(bodyMap: dataMap, signMap: dataMap)
        DCAlamofireManager.shared.request(url: DCApiList.sysProvince, vo: vo) { response in
            if let json = response,let provinceList = json["provinceList"] as? [[String: Any]] {
                dealResult(dictionaryList: provinceList) { list in
                    successHandler(list)
                }
            }
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler()
        }
    }
    
    
    static func getBankList(successHandler:@escaping SystemDictModelLoadSuccessHandler,
                            failHandler:DCAlamofireManagerFailHandler? = nil,
                            completionHandler:@escaping(()->())){
        
        let vo = DCRequestParametersModel.init(bodyMap: nil, signMap: nil)
        DCAlamofireManager.shared.request(url: DCApiList.sysBank, vo: vo) { response in
            if let json = response,let bankList = json["bankList"] as? [[String: Any]] {
                dealResult(dictionaryList: bankList) { list in
                    successHandler(list)
                }
            }
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler()
        }
    }
    
    
    
    
    static func getCities(provinceId:String,
                          successHandler:@escaping SystemDictModelLoadSuccessHandler,
                          failHandler:DCAlamofireManagerFailHandler? = nil,
                          completionHandler:@escaping(()->())){
        
        let dataMap = ["countryId": 52, "provinceId": provinceId] as [String: Any]
        let vo = DCRequestParametersModel.init(bodyMap: dataMap, signMap: dataMap)
        DCAlamofireManager.shared.request(url: DCApiList.sysCity, vo: vo) { response in
            if let json = response,let cityList = json["cityList"] as? [[String: Any]] {
                dealResult(dictionaryList: cityList) { list in
                    successHandler(list)
                }
            }
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler()
        }
    }
    
    

}
