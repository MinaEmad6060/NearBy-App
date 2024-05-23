//
//  NearByLocations.swift
//  NearByApp
//
//  Created by Mina Emad on 22/05/2024.
//

import Foundation


class NearByLocations: Codable{
    var results: [Result] = [Result]()
}

class Result: Codable{
    var categories: [CategoryOfLacation] = [CategoryOfLacation]()
    var location: Location?
    var name: String?
}

class CategoryOfLacation: Codable{
    var plural_name: String?
    var icon: Icon?
}

class Location: Codable{
    var country: String?
    var region: String?
}

class Icon: Codable{
    var prefix: String?
    var suffix: String?
}
