//
//  ServiceContainer.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 10/10/2020.
//

import Foundation

class ServiceContainer {
    static let currencyNetworkManager = CurrencyNetworkManager()
    static let weatherNetworkManager = WeatherNetworkManager()
    static let weatherIconNetworkManager = WeatherIconNetworkManager()
    static let translationNetworkManager = TranslationNetworkManager()
    static let alertManager = AlertManager()
}
