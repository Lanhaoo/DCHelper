//
//  DCEventRecorder.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/5.
//

public enum DCEvent:String{
    case firstOpenApp
    case openLoginPage
    case loginCode
    case loginLoginButtonAction
    case homebuttonclick
    case livenessStartBtnAction
    case livenessCameraAlert
    case livenessCameraAlertSucc
    case livenessCameraAlertFail
    case livenessSetCAlert
    case livenessSetCAlertAction
    case livenessCameraShow
    case livenessCameraTakePhoto
    case taxSelected
    case taxSelectedCamera
    case taxCameraAlert
    case taxCameraAlertSucc
    case taxCameraAlertFail
    case taxCameraSettingAlert
    case taxCameraSetAlertAction
    case baseCameraPage
    case baseCameraPBackA
    case baseCameraTakePhoto
    case baseCameraPhotoSure
    case baseCameraPhotoAgain
    case taxPhotoPage
    case taxPhotoPageSelImg
    case fullpersonalinfo
    case personalinfobutton
    case fullworkinfo
    case workinfobutton
    case fullcontactinfo
    case contactinfobutton
    case fullaccountinfo
    case accountinfobutton
    case autoApply
    case productAmountChanged
    case productAmountAdd
    case productAmountReduce
    case productermChanged
    case productApplyAction
    case productLocationAlert
    case productLocationSucc
    case productLcaAlertFail
    case productLcaSetAlt
    case productLcaSetAltAct
    case ezl_productLcaUpdateSucc
    case ezl_productLcaUpdateFail
}
public struct DCEventRecorder {

    public static func add(event: DCEvent) {
        let eventCode = DCAppConfigManager.shared.appId + "_" + event.rawValue
        let dataMap = ["eventCode": eventCode.subString(to: 32),
                       "eventContent": eventCode,
                       "remark1": "NULL",
                       "remark2": "NULL",
                       "remark3": "NULL"] as [String: Any]
        let vo = DCRequestParametersModel(bodyMap: dataMap, signMap: dataMap)
        DCRequest.request(url: DCApiList.buryRecord, vo: vo) { _ in
            print("埋点成功:",event.rawValue)
        }
    }
    
}
