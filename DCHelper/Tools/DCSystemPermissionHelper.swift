//
//  DCSystemPermissionHelper.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/5.
//

import UIKit
import Photos
import Contacts
import CoreLocation
public enum DCSystemPermissionStatus: Int {
    case notDetermined
    case denied
    case authorized
}
public enum DCSystemPermissionType: String {
    case camera
    case contactStore
    case location
}

public final class DCSystemPermissionHelper: NSObject {

    public static let shared = DCSystemPermissionHelper()
    
    public func request(with type:DCSystemPermissionType,completion: @escaping (Bool) -> ()){
        switch type {
        case .camera:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .location:
            DCLocationAuthorizationHelper.shared.request()
            DCLocationAuthorizationHelper.shared.statusChangedHandler = { res in
                DispatchQueue.main.async {
                    completion(res)
                }
            }
        case .contactStore:
            let store = CNContactStore()
            store.requestAccess(for: .contacts) { (granted, error) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }
    
    public func authorizationStatus(with type:DCSystemPermissionType) -> DCSystemPermissionStatus {
        switch type {
        case .camera:
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            if cameraAuthorizationStatus == .notDetermined {
                return .notDetermined
            } else if cameraAuthorizationStatus == .authorized {
                return .authorized
            } else {
                return .denied
            }
        case .location:
            let status = CLLocationManager.authorizationStatus()
            if status == .notDetermined {
                return .notDetermined
            } else if status == .denied || status == .restricted {
                return .denied
            } else{
                return .authorized
            }
        case .contactStore:
            let status = CNContactStore.authorizationStatus(for: .contacts)
            if status == .notDetermined {
                return .notDetermined
            } else if status == .authorized {
                return .authorized
            } else {
                return .denied
            }
        }
    }
    
}
