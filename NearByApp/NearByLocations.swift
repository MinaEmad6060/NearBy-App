//
//  NearByLocations.swift
//  NearByApp
//
//  Created by Mina Emad on 22/05/2024.
//

import Foundation


class NearByLocations{
    var results: [Result] = [Result]()
}

class Result{
    var categories: [CategoryOfLacation] = [CategoryOfLacation]()
    var location: Location?
    var name: String?
}

class CategoryOfLacation{
    var plural_name: String?
    var icon: Icon?
}

class Location{
    var address: String?
    var country: String?
}

class Icon{
    var prefix: String?
    var suffix: String?
}
