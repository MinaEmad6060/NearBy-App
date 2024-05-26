//
//  HomeViewModel.swift
//  NearByApp
//
//  Created by Mina Emad on 24/05/2024.
//

import Foundation


class HomeViewModel: HomeViewModelProtocol{
    var bindPlacesToViewController: (() -> ())?
    var bindNetworkStatusToViewController: (() -> ())?
    
    var fetchDataFromAPI: FetchDataFromAPI?
    var networkConnection: NetworkConnection?
    
    var isOnline: Bool?{
        didSet{
            (bindNetworkStatusToViewController ?? {})()
        }
    }
    
    var nearLocations : NearLocations?{
        didSet{
            (bindPlacesToViewController ?? {})()
        }
    }
    
    @available(iOS 13.0.0, *)
    func getNearLocationsFromApi() {
        fetchDataFromAPI = FetchDataFromAPI()
        fetchDataFromAPI?.getNearLocations{ nearLocations in
            self.nearLocations = nearLocations
        }
    }
    
    func checkNetworkConnection(){
        networkConnection = NetworkConnection()
        if networkConnection!.isNetworkReachable() {
            UserDefaults.standard.set("true", forKey: "Online")
        } else {
            UserDefaults.standard.set("false", forKey: "Online")
            if isOnline ?? true {
                isOnline = false
            }else{
                isOnline = true
            }
        }
    }
    
}
