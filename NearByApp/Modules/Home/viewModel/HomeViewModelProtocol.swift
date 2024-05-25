//
//  HomeViewModelProtocol.swift
//  NearByApp
//
//  Created by Mina Emad on 24/05/2024.
//

import Foundation


protocol HomeViewModelProtocol{
    
    @available(iOS 13.0.0, *)
    func getNearLocationsFromApi()
    func checkNetworkConnection()
    
    var bindPlacesToViewController: (() -> ())? { get set }
    var bindNetworkStatusToViewController: (() -> ())? { get set }
    var nearLocations: NearLocations? { get set }
    
}
