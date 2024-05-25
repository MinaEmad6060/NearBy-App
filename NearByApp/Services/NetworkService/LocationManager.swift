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
        
        let updatedLat = location.coordinate.latitude
        let updatedLon = location.coordinate.longitude
        let currentLat = LocationManager.currentLocation?.coordinate.latitude
        let currentLon = LocationManager.currentLocation?.coordinate.longitude
        LocationManager.distance = self.calculateDistance(fromLatitude: updatedLat, fromLongitude: updatedLon, toLatitude: currentLat ?? 0.0, toLongitude: currentLon ?? 0.0)
        print("currentLat : \(currentLat ?? 0.0) \n currentLon\(currentLon ?? 0.0)")
       
        if LocationManager.distance >= 200 {
            LocationManager.currentLocation=locations.first
            print("Reset")
        }
        
        
        
        completion?(location)
//        manager.stopUpdatingLocation()
    }
    
    
    func calculateDistance(fromLatitude latitude1: Double, fromLongitude longitude1: Double, toLatitude latitude2: Double, toLongitude longitude2: Double) -> CLLocationDistance {
        let coordinate1 = CLLocation(latitude: latitude1, longitude: longitude1)
        let coordinate2 = CLLocation(latitude: latitude2, longitude: longitude2)
        
        return coordinate1.distance(from: coordinate2)
    }
    
}
