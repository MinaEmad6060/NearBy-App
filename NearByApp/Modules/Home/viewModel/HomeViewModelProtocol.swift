//
//  HomeViewModelProtocol.swift
//  NearByApp
//
//  Created by Mina Emad on 24/05/2024.
//

import Foundation


protocol HomeViewModelProtocol{
    var bindResultToViewController: (() -> ())? { get set }
    var nearLocations: NearLocations? { get set }
    @available(iOS 13.0.0, *)
    func getNearLocationsFromApi()
}
