//
//  Weather.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 11/10/2020.
//

import Foundation

struct Weather {
    let city: Cities
    let description: String
    let temperature: Double
    let icon: String
    var iconData: Data?
}
