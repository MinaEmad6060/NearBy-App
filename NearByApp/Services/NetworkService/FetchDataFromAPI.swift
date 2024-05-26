//
//  FetchDataFromAPI.swift
//  NearByApp
//
//  Created by Mina Emad on 22/05/2024.
//

import Foundation


class FetchDataFromAPI{
    
    var response: NearLocations?
    func getNearLocations(handler: @escaping (NearLocations)->Void) {
        let request = setupRequest()
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            self.decodeData(decoder: JSONDecoder(), data: data, handler: handler)
        }
        task.resume()
    }
    
    func setupRequest() -> URLRequest{
        let url = setupURL()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "fsq3meiPpkSU0+KSYY1+8nxVTT+8ZxV4lGL11CySb31HpjY="
        ]
        return request
    }
    
    func setupURL() -> URL{
        let currentLat = LocationManager.currentLocation?.coordinate.latitude
        let currentLon = LocationManager.currentLocation?.coordinate.longitude
        let url = URL(string: "https://api.foursquare.com/v3/places/nearby?ll=\(currentLat ?? -1),\(currentLon ?? -1)&radius=1000")!
        return url
    }
    
    func decodeData(decoder : JSONDecoder ,data: Data?,handler: @escaping (NearLocations)->Void){
        do{
            let decoder = JSONDecoder()
            if let data = data {
                let json = try decoder.decode(NearLocations.self, from: data)
                let nearLocations = json
//                UserDefaults.standard.set("success", forKey: "GetData")
                handler(nearLocations)
            }
        }catch{
            UserDefaults.standard.set("error", forKey: "GetData")
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
    
   
    
}
