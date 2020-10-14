//
//  ServiceContainer.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 10/10/2020.
//

import Foundation

class ServiceContainer {
    static let currencyNetworkManager = CurrencyNetworkManager()
    static let savignyWeatherNetworkManager = WeatherNetworkManager()
    static let newYorkWeatherNetworkManager = WeatherNetworkManager()
    static let translationNetworkManager = TranslationNetworkManager()
    static let alertManager = AlertManager()
}
