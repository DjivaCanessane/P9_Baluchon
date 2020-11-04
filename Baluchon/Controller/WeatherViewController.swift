//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 07/10/2020.
//

import UIKit

class WeatherViewController: UIViewController {
    // MARK: - PROPERTIES
    private let weatherNetworkManager = ServiceContainer.weatherNetworkManager
    private let weatherIconNetworkManager = ServiceContainer.weatherIconNetworkManager
    private let alertManager = ServiceContainer.alertManager

    // MARK: - IBOUTLETS
    // Savigny's outlets
    @IBOutlet weak var savignyIcon: UIImageView!
    @IBOutlet weak var savignyTemperature: UILabel!
    @IBOutlet weak var savignyDescription: UILabel!

    //NewYork's outlets
    @IBOutlet weak var newYorkIcon: UIImageView!
    @IBOutlet weak var newYorkTemperature: UILabel!
    @IBOutlet weak var newYorkDescription: UILabel!

    // MARK: - FUNCTIONS
    override func viewWillAppear(_ animated: Bool) {
        weatherNetworkManager.getWeather(city: .savignyLeTemple) { (result) in
            switch result {
            // In case of sucess, we try to get iconData
            case .success(let weatherWithoutIcon):
                self.weatherIconNetworkManager.getIconData(weather: weatherWithoutIcon) { result in
                    switch result {
                    // Display Savigny Weather
                    case .success(let weatherWithIcon):
                        self.displaySavignyWeather(weather: weatherWithIcon)
                    // In case of failure, we show the error message through an alert
                    case .failure(let error):
                        self.alertManager.showErrorAlert(
                            title: "Error",
                            message: error.msg,
                            viewController: self)
                    }
                }
            // In case of failure, we show the error message through an alert
            case .failure(let error):
                self.alertManager.showErrorAlert(
                    title: "Error",
                    message: error.msg,
                    viewController: self)
            }
        }

        weatherNetworkManager.getWeather(city: .newYork) { (result) in
            switch result {
            // In case of sucess, we try to get iconData
            case .success(let weatherWithoutIcon):
                self.weatherIconNetworkManager.getIconData(weather: weatherWithoutIcon) { result in
                    switch result {
                    // Display New York Weather
                    case .success(let weatherWithIcon):
                        self.displayNewYorkWeather(weather: weatherWithIcon)
                    // In case of failure, we show the error message through an alert
                    case .failure(let error):
                        self.alertManager.showErrorAlert(
                            title: "Error",
                            message: error.msg,
                            viewController: self)
                    }
                }
            // In case of failure, we show the error message through an alert
            case .failure(let error):
                self.alertManager.showErrorAlert(
                    title: "Error",
                    message: error.msg,
                    viewController: self)
            }
        }
    }

    /// Fetch data on thes views concerning NewYork
    private func displayNewYorkWeather(weather: Weather) {
        guard let newYorkIconData = weather.iconData else {
            return alertManager.showErrorAlert(
                title: "Error",
                message: "Invalid image data for New York weather.",
                viewController: self
            )
        }
        let iconImagenewYork = UIImage(data: newYorkIconData)
        newYorkIcon.image = iconImagenewYork
        newYorkTemperature.text = "\(Int(round(weather.temperature))) °C"
        newYorkDescription.text = weather.description
    }

    /// Fetch data on thes views concerning Savigny
    private func displaySavignyWeather(weather: Weather) {
        guard let savignyIconData = weather.iconData else {
            return alertManager.showErrorAlert(
                title: "Error",
                message: "Invalid image data for Savigny le temple weather.",
                viewController: self
            )
        }
        let iconImageSavigny = UIImage(data: savignyIconData)
        savignyIcon.image = iconImageSavigny
        savignyTemperature.text = "\(Int(round(weather.temperature))) °C"
        savignyDescription.text = weather.description
    }
}
