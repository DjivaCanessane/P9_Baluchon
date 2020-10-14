//swiftlint:disable vertical_whitespace
//  WeatherNetworkManager.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 10/10/2020.
//

import Foundation

class WeatherNetworkManager {

    // MARK: - Internal

    // MARK: Inits

    // This init will permits to inject dependency for testing this class
    init(weatherSession: URLSession = URLSession(configuration: .default)) {
        self.weatherSession = weatherSession
    }



    // MARK: Methods



    // MARK: - Private

    // MARK: Properties

    private var weatherSession: URLSession
    private var task: URLSessionDataTask?

    private let weatherNetworkService: NetworkService = NetworkService()


    // MARK: Methods

    /// Returns the actual weather for the selected city
    func getWeather(city: City, callback: @escaping (Result<Weather, NetworkError>) -> Void) {
        let weatherUrl = URL(
            string: "https://api.openweathermap.org/data/2.5/weather?q=\(city.name)&appid=\(WEATHER_KEY)&units=metric")!

        // Try to get data from the weatherUrl
        weatherNetworkService.getNetworkResponse(with: weatherUrl) { result in
            switch result {

            // In case of failure, we pass the error to WeatherViewController callback
            case .failure(let error): callback(.failure(error))

            // In case of success, we decode the data, then we pass the rate to WeatherViewController callback
            case .success(let data):
                let parsedData = self.createWeatherFromData(city: city, data: data)
                switch parsedData{
                case .failure(let error): callback(.failure(error))
                case .success(let weatherMissingIconData):
                    self.getIconData(weather: weatherMissingIconData) { result in
                        switch result {
                        // Append complete to weathers dictionnary
                        case .success(let weatherWithIcon):
                            callback(.success(weatherWithIcon))
                        // In case of failure, we pass the error to WeatherViewController callback
                        case .failure(let error):
                            callback(.failure(error))
                        }
                    }
                }



            }
        }
    }

    /// Converts raw data into Weather object
    private func createWeatherFromData(
        city: City, data: Data) -> Result<Weather, NetworkError> {
        /* Decode the data according to type Weather,
         if not we throw an error via the callback to WeatherViewController */
        guard let weatherData = try? JSONDecoder().decode(WeatherDataStruct.self, from: data) else {
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

    /// Get icon data from icon string of weather object
    private func getIconData(weather: Weather, callback:@escaping (Result<Weather, NetworkError>) -> Void) {
        let iconUrl = URL(
            string: "http://openweathermap.org/img/wn/\(weather.iconString)@2x.png")!

        // Try to get data from the weatherUrl
        weatherNetworkService.getNetworkResponse(with: iconUrl) { result in
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
