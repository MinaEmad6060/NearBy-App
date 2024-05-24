//
//  FetchDataFromAPI.swift
//  NearByApp
//
//  Created by Mina Emad on 22/05/2024.
//

import Foundation


class FetchDataFromAPI{
    
    var response: NearByLocations?
    //https://api.foursquare.com/v3/places/nearby
    //https://api.foursquare.com/v3/places/nearby?ll=48.8583701,2.2944813
    @available(iOS 13.0.0, *)
    func getNearLocations() async -> NearByLocations? {
        let currentLat = LocationManager.currentLocation?.coordinate.latitude
        let currentLon = LocationManager.currentLocation?.coordinate.longitude
        let url = URL(string: "https://api.foursquare.com/v3/places/nearby?ll=\(currentLat ?? 0.0),\(currentLon ?? 0.0)")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
              "accept": "application/json",
              "Authorization": "fsq3meiPpkSU0+KSYY1+8nxVTT+8ZxV4lGL11CySb31HpjY="
            ]

            do{
                let (data, _) = try await URLSession.shared.data(for: request)
                let decoder = JSONDecoder()
               
                response = try decoder.decode(NearByLocations.self, from: data)
                print("My Result => \(response?.results[0].name ?? "none")")
            }catch{
                print("Error while fetching data")
            }
            return response
        }
}
