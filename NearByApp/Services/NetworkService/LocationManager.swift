//
//  LocationManager.swift
//  NearByApp
//
//  Created by Mina Emad on 23/05/2024.
//

import Foundation
import CoreLocation


class LocationManager: NSObject, CLLocationManagerDelegate{
    static let shared = LocationManager()
    static var currentLocation: CLLocation?
    
    let manager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)?
    
    public func getUserLocation(comletion: @escaping ((CLLocation) -> Void)){
        self.completion = comletion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.first else {
            return
        }
        
        if LocationManager.currentLocation == nil {
            LocationManager.currentLocation=locations.first
        }
        
        completion?(location)
//        manager.stopUpdatingLocation()
    }
    
}
