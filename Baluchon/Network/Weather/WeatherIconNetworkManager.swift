//
//  WeatherIconNetworkManager.swift
//  Baluchon
//
//  Created by Djiveradjane Canessane on 30/10/2020.
//

import Foundation

class WeatherIconNetworkManager {
    // MARK: Properties
    private var weatherIconNetworkService: NetworkService = NetworkService()

    // This init will permits to inject dependency for testing this class
    init(weatherIconNetworkService: NetworkService = NetworkService()) {
        self.weatherIconNetworkService = weatherIconNetworkService
    }

    // MARK: Functions
    /// Get icon data from icon string of weather object
    func getIconData(weather: Weather, callback:@escaping (Result<Weather, NetworkError>) -> Void) {
        let iconUrl = URL(
            string: "http://openweathermap.org/img/wn/\(weather.iconString)@2x.png")!

        // Try to get data from the weatherUrl
        weatherIconNetworkService.getNetworkResponse(with: iconUrl) { result in
            switch result {

            // In case of failure, we pass the error to WeatherViewController callback
            case .failure(let error): callback(.failure(error))

            // In case of success, we decode the data, then we pass the rate to WeatherViewController callback
            case .success(let data):
                var weaterWithIconData = weather
                weaterWithIconData.iconData = data
                callback(.success(weaterWithIconData))
            }
        }
    }

}
