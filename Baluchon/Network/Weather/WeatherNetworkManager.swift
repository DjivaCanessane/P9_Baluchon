//  WeatherNetworkManager.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 10/10/2020.
//

import Foundation

class WeatherNetworkManager {
    // MARK: - PROPERTIES
    private var weatherNetworkService: NetworkService = NetworkService()

    // MARK: - FUNCTIONS
    // MARK: Internal
    // This init will permits to inject dependency for testing this class
    init(weatherNetworkService: NetworkService = NetworkService()) {
        self.weatherNetworkService = weatherNetworkService
    }

    /// Returns the actual weather for the selected city
    func getWeather(city: City, callback: @escaping (Result<Weather, NetworkError>) -> Void) {
        let rawURL = String(
            format: "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@&units=metric",
            city.name,
            Constants.Keys.weatherKey
        )
        let weatherUrl = URL(string: rawURL)!

        // Try to get data from the weatherUrl
        weatherNetworkService.getNetworkResponse(with: weatherUrl) { result in
            switch result {

            // In case of failure, we pass the error to WeatherViewController callback
            case .failure(let error): callback(.failure(error))

            // In case of success, we decode the data, then we pass the rate to WeatherViewController callback
            case .success(let data):
                let parsedData = self.createWeatherFromData(city: city, data: data)
                switch parsedData {
                case .failure(let error): callback(.failure(error))
                case .success(let weatherWithoutIconData): callback(.success(weatherWithoutIconData))
                }
            }
        }
    }

    // MARK: Private
    /// Converts raw data into Weather object
    private func createWeatherFromData(
        city: City, data: Data) -> Result<Weather, NetworkError> {
        /* Decode the data according to type Weather,
         if not we throw an error via the callback to WeatherViewController */
        guard let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) else {
            return .failure(.canNotDecode)
        }

        // Extract the temperature, weather description and icon from decodedData
        guard let weatherElement = weatherData.weather.first else {
            return .failure(.wrongParsing)
        }
        let description: String = weatherElement.description
        let iconString: String = weatherElement.icon
        let temperature: Double = weatherData.main.temp

        let weather =
            Weather(city: city, description: description, temperature: temperature, iconString: iconString)
        return .success(weather)
    }

}
