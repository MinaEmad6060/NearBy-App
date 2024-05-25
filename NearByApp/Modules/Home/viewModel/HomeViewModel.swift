//
//  HomeViewModel.swift
//  NearByApp
//
//  Created by Mina Emad on 24/05/2024.
//

import Foundation


class HomeViewModel: HomeViewModelProtocol{
    var bindResultToViewController: (() -> ())?
    
   
    var fetchDataFromAPI: FetchDataFromAPI?
        var nearLocations : NearLocations?{
        didSet{
            (bindResultToViewController ?? {})()
        }
    }
    
    @available(iOS 13.0.0, *)
    func getNearLocationsFromApi() {
        fetchDataFromAPI = FetchDataFromAPI()
            fetchDataFromAPI?.getNearLocations{ nearLocations in
                self.nearLocations = nearLocations
            }
    }
    
    
    
    
}
