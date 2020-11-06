//
//  Weather.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 10/10/2020.
//

import Foundation

// MARK: - Weather
struct WeatherData: Codable {
    let weather: [WeatherElement]
    let main: Main
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let description, icon: String
}
