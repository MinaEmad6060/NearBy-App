//
//  FetchDataFromAPI.swift
//  NearByApp
//
//  Created by Mina Emad on 22/05/2024.
//

import Foundation


class FetchDataFromAPI{
    
    var response: NearByLocations?
    
    @available(iOS 13.0.0, *)
    func getNearLocations() async -> NearByLocations? {
            let url = URL(string: "https://api.foursquare.com/v3/places/nearby?ll=48.8583701,2.2944813")!
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
    

//    @available(iOS 13.0.0, *)
//    func getNearLocations() async {
//        let url = URL(string: "https://api.foursquare.com/v3/places/nearby")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.timeoutInterval = 10
//        request.allHTTPHeaderFields = [
//            "accept": "application/json",
//            "Authorization": "fsq3meiPpkSU0+KSYY1+8nxVTT+8ZxV4lGL11CySb31HpjY="
//        ]
//
//        do {
//            let (data, _) = try await URLSession.shared.data(for: request)
//            print(String(decoding: data, as: UTF8.self))
//        } catch {
//            print("Error while fetching data")
//        }
//    }
//
//    func getNearLocationsForEarlierVersions(completion: @escaping (Data?, Error?) -> Void) {
//        let url = URL(string: "https://api.foursquare.com/v3/places/nearby")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.timeoutInterval = 10
//        request.allHTTPHeaderFields = [
//            "accept": "application/json",
//            "Authorization": "fsq3meiPpkSU0+KSYY1+8nxVTT+8ZxV4lGL11CySb31HpjY="
//        ]
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(nil, error)
//            } else if let data = data {
//                completion(data, nil)
//            }
//        }
//        task.resume()
//    }
//    
//    func parseJSONData(data: Data) -> [NearByLocations]? {
//        do {
//            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//               let results = json["results"] as? [[String: Any]] {
//                var places = [NearByLocations]()
//                for result in results {
//                    let place = NearByLocations()
//                    places.append(place)
//                }
//                return places
//            }
//        } catch {
//            print("Error parsing JSON data: \(error.localizedDescription)")
//        }
//        return nil
//    }
//    
}
