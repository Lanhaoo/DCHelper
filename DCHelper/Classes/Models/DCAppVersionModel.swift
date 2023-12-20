//
//  DCAppVersionModel.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/13.
//

import Foundation
public class DCAppVersionModel:DCBaseModel,DCModelConvertible{
    public typealias ClassName = DCAppVersionModel
    var latestVersionContent = ""
    var latestForceVersion = ""
    var latestVersionUrl = ""
    var latestForceVersionContent = ""
    var latestForceVersionUrl = ""
    var latestVersion = ""
}

public extension DCAppVersionModel{
    
    static func isNewVersion(_ versionNumber: String) -> Bool {
        guard let currentVersion = ez.appVersion else {
            return false
        }
        let componentsA = currentVersion.components(separatedBy: ".").compactMap { Int($0) }
        let componentsB = versionNumber.components(separatedBy: ".").compactMap { Int($0) }
        for (a, b) in zip(componentsA, componentsB) {
            if a < b {
                return true
            } else if a > b {
                return false
            }
        }
        return componentsA.count < componentsB.count
    }
    
    static func getNewVersion(successHandler: @escaping((DCAppVersionModel)->()),
                                  failHandler:DCAlamofireManagerFailHandler? = nil,
                                  completionHandler:DCAlamofireManagerCompletionHandler? = nil){
        let vo = DCRequestParametersModel(bodyMap: nil, signMap: nil)
        DCAlamofireManager.shared.request(url: DCApiList.appVersion, vo: vo) { response in
            if let responseJson = response,let vo = DCAppVersionModel.convertModel(with: responseJson) {
                successHandler(vo)
            }
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler?()
        }
    }
}
