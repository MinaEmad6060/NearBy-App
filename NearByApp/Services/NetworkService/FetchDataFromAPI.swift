//
//  FetchDataFromAPI.swift
//  NearByApp
//
//  Created by Mina Emad on 22/05/2024.
//

import Foundation


class FetchDataFromAPI{
    
    var response: NearLocations?
    //https://api.foursquare.com/v3/places/nearby
    //https://api.foursquare.com/v3/places/nearby?ll=48.8583701,2.2944813
    //https://api.foursquare.com/v3/places/nearby?ll=\(currentLat ?? 0.0),\(currentLon ?? 0.0)
    func getNearLocations(handler: @escaping (NearLocations)->Void) {
        let currentLat = LocationManager.currentLocation?.coordinate.latitude
        let currentLon = LocationManager.currentLocation?.coordinate.longitude
        let url = URL(string: "https://api.foursquare.com/v3/places/nearby?ll=\(currentLat ?? -1),\(currentLon ?? -1)")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
              "accept": "application/json",
              "Authorization": "fsq3meiPpkSU0+KSYY1+8nxVTT+8ZxV4lGL11CySb31HpjY="
            ]

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            
            
            do{
                let decoder = JSONDecoder()
                if let data = data {
                    let json = try decoder.decode(NearLocations.self, from: data)
                    let nearLocations = json
                    UserDefaults.standard.set("success", forKey: "Online")
                    handler(nearLocations)
                }
            }catch{
                UserDefaults.standard.set("error", forKey: "Online")
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
