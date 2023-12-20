//
//  DCLocationHelper.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/7.
//

import UIKit
import CoreLocation
public final class DCLocationHelper: NSObject {
    
    public  var locationSuccessHandler: ((String,String) -> ())?
    
    public var locationFailHandler: (() -> ())?
    
    public static let shared = DCLocationHelper()
    
    private let locationManager = CLLocationManager()
    
    private override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    public func startLocation() {
        locationManager.requestLocation()
    }
    
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension DCLocationHelper: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationSuccessHandler?("\(location.coordinate.latitude)","\(location.coordinate.longitude)")
        stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationFailHandler?()
        stopUpdatingLocation()
    }
}
