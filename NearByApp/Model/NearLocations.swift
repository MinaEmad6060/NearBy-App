//
//  NearLocations.swift
//  NearByApp
//
//  Created by Mina Emad on 22/05/2024.
//

import Foundation


struct NearLocations: Codable{
    var results: [Result] = [Result]()
}

struct Result: Codable{
    var categories: [CategoryOfLacation] = [CategoryOfLacation]()
    var location: Location?
    var name: String?
}

struct CategoryOfLacation: Codable{
    var plural_name: String?
    var icon: Icon?
}

struct Location: Codable{
    var country: String?
    var region: String?
}

struct Icon: Codable{
    var prefix: String?
    var suffix: String?
}
