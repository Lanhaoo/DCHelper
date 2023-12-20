//
//  DCAlamofireManager.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/11/29.
//

import Foundation
import Alamofire
import HandyJSON

public typealias DCAlamofireManagerError = (message: String,code: Int)
public typealias DCAlamofireManagerSuccessHandler = ((_ response:[String:Any]?) -> Void)
public typealias DCAlamofireManagerFailHandler = (_ error: DCAlamofireManagerError) -> Void
public typealias DCAlamofireManagerCompletionHandler = () -> Void

public let DCRequest = DCAlamofireManager.shared

public final class DCAlamofireManager{
    
    public static let shared = DCAlamofireManager()
    
}

public extension DCAlamofireManager{
    
    func request(url:String,
                 vo:DCRequestParametersModel,
                 successHandler: DCAlamofireManagerSuccessHandler? = nil,
                 failHandler:DCAlamofireManagerFailHandler? = nil,
                 completionHandler:DCAlamofireManagerCompletionHandler? = nil){
        let urlStr = DCAppConfigManager.shared.URLDomain + url
        AF.request(urlStr,
                   method: .post,
                   parameters: vo.toJSON(),
                   encoding: JSONEncoding.default).validate().responseJSON { response in
            completionHandler?()
            self.handleResponse(url: url, response: response) { model in
                successHandler?(model)
            } failHandler: { error in
                failHandler?(error)
            }
        }
    }
    
    
    func uploadImage(image: DCImage,
                     successHandler:@escaping((String)->()),
                     failHandler:DCAlamofireManagerFailHandler? = nil,
                     completionHandler:DCAlamofireManagerCompletionHandler? = nil)
    {
        let vo = DCRequestParametersModel(bodyMap: nil, signMap: nil)
        AF.upload(multipartFormData: { multiPart in
            for p in vo.toJSON()! {
                multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
            }
            multiPart.append(image.data, withName: "file", fileName: "\(StringProcessing.generateNowTimeInterval()).jpg", mimeType: "image/jpg")
        }, to: DCAppConfigManager.shared.URLDomain + DCApiList.upload, method: .post).responseJSON(completionHandler: { data in
            completionHandler?()
            self.handleResponse(url: DCAppConfigManager.shared.URLDomain + DCApiList.upload, response: data) { response in
                if let dict = response,let src = dict["src"] as? String{
                    successHandler(src)
                }
            } failHandler: { error in
                failHandler?(error)
            }
        })
    }
    
    func uploadImageList(imageList:[DCImage],
                         completionHandler:@escaping ((_ urls:String)->())) {
        if imageList.count <= 0 {
            completionHandler("")
            return
        }
        var imageUrlList = [String]()
        let group = DispatchGroup()
        let concurrentQueue = DispatchQueue(label: "imageUploadQueue", attributes: .concurrent)
        for data in imageList {
            concurrentQueue.async(group: group) {
                group.enter()
                self.uploadImage(image: data) { src in
                    imageUrlList.append(src)
                } completionHandler: {
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            let pictureUrl = imageUrlList.reduce("", { result, element in
                return result.isEmpty ? element : result + "," + element
            })
            completionHandler(pictureUrl)
        }
    }
    
    
    func commmitUserFeedBackData(userMobile:String,
                                 description:String,
                                 contactWay:String,
                                 whatsApp:String,
                                 pictureUrl:String,
                                 score:String,
                                 successHandler:@escaping(()->()),
                                 failHandler:DCAlamofireManagerFailHandler? = nil,
                                 completionHandler:DCAlamofireManagerCompletionHandler? = nil){
        let dataMap = ["userMobile":userMobile,
                       "description":description,
                       "contactWay":contactWay,
                       "whatsApp":whatsApp,
                       "pictureUrl":pictureUrl,
                       "score":score]
        let vo = DCRequestParametersModel(bodyMap: dataMap, signMap: nil)
        request(url: DCApiList.problemFeedback, vo: vo) { response in
            successHandler()
        } failHandler: { error in
            failHandler?(error)
        } completionHandler: {
            completionHandler?()
        }
    }
}

extension DCAlamofireManager{
    
    private func handleResponse(url:String,
                                response:AFDataResponse<Any>,
                                successHandler: DCAlamofireManagerSuccessHandler? = nil,
                                failHandler:DCAlamofireManagerFailHandler? = nil){
        do {
            let get = try response.result.get()
            guard let json = get as? [String:Any],let responseVO = DCResponseModel.convertModel(with: json) else {
                let errorResponse: DCAlamofireManagerError = ("", response.error?.responseCode ?? 0)
                failHandler?(errorResponse)
                return
            }
            print(url,json)
            if responseVO.resultCode == 200 {
                successHandler?(responseVO.data)
            }else if responseVO.resultCode == 2000001 || responseVO.resultCode == 2000002 || responseVO.resultCode == 2002001{
                DCUserDefaultsHelper.clearUserInfo()
                NotificationCenter.default.post(name: UserNeedLoginNotification, object: nil)
            }else if responseVO.resultCode == 2009006{
                NotificationCenter.default.post(name: AppNewVersionNotification, object: nil)
            }else{
                let errorResponse: DCAlamofireManagerError = (responseVO.resultMsg,responseVO.resultCode)
                failHandler?(errorResponse)
            }
        }catch{
            let errorResponse: DCAlamofireManagerError = (error.localizedDescription, response.error?.responseCode ?? 0)
            failHandler?(errorResponse)
        }
    }
}

public let UserNeedLoginNotification = Notification.Name(rawValue: "UserNeedLoginNotification")

public let AppNewVersionNotification = Notification.Name(rawValue: "AppNewVersionNotification")
