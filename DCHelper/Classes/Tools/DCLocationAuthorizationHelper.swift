//
//  DCLocationAuthorizationHelper.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/7.
//

import UIKit
import CoreLocation
public final class DCLocationAuthorizationHelper: NSObject,CLLocationManagerDelegate {

    public static let shared = DCLocationAuthorizationHelper()
    
    private let locationManager = CLLocationManager()
    
    public var statusChangedHandler: ((Bool) -> ())?
    
    private override init() {
        super.init()
    }
    
    public func request() {
        self.locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            return
        }
        if status == .denied{
            statusChangedHandler?(false)
            self.locationManager.delegate = nil
        }else{
            self.locationManager.delegate = self
            if status == .authorizedAlways || status == .authorizedWhenInUse{
                statusChangedHandler?(true)
            }
        }
    }
    
}
