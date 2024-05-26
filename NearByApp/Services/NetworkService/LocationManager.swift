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
    static var distance = 0.0
    
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
        
//        let updatedLat = location.coordinate.latitude
//        let updatedLon = location.coordinate.longitude
//        let currentLat = LocationManager.currentLocation?.coordinate.latitude
//        let currentLon = LocationManager.currentLocation?.coordinate.longitude
        LocationManager.distance = calculateDistanceMeters(location: location)
       
        if LocationManager.distance >= 200 {
            LocationManager.currentLocation=locations.first
        }
        
        checkApplicationMode()
        
//        if let mode = UserDefaults.standard.string(forKey: "Mode"),
//           let isOnline = UserDefaults.standard.string(forKey: "Online"){
//            if mode == "SingleUpdate" || isOnline == "false" {
//                manager.stopUpdatingLocation()
//            }
//        }
        
        completion?(location)
    }
    
    func calculateDistanceMeters(location: CLLocation) -> Double{
        let updatedLat = location.coordinate.latitude
        let updatedLon = location.coordinate.longitude
        let currentLat = LocationManager.currentLocation?.coordinate.latitude
        let currentLon = LocationManager.currentLocation?.coordinate.longitude
        return self.calculateDistanceCoordinates(fromLatitude: updatedLat, fromLongitude: updatedLon, toLatitude: currentLat ?? 0.0, toLongitude: currentLon ?? 0.0)
    }
    
    
    func calculateDistanceCoordinates(fromLatitude latitude1: Double, fromLongitude longitude1: Double, toLatitude latitude2: Double, toLongitude longitude2: Double) -> CLLocationDistance {
        let coordinate1 = CLLocation(latitude: latitude1, longitude: longitude1)
        let coordinate2 = CLLocation(latitude: latitude2, longitude: longitude2)
        
        return coordinate1.distance(from: coordinate2)
    }
    
    
    func checkApplicationMode(){
        if let mode = UserDefaults.standard.string(forKey: "Mode"),
           let isOnline = UserDefaults.standard.string(forKey: "Online"){
            if mode == "SingleUpdate" || isOnline == "false" {
                manager.stopUpdatingLocation()
            }
        }
    }
    
}
