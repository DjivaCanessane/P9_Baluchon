//
//  Weather.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 11/10/2020.
//

import Foundation

struct Weather {
    let city: City
    let description: String
    let temperature: Double
    let iconString: String
    var iconData: Data?
}
