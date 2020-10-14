//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 07/10/2020.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var savignyIcon: UIImageView!
    @IBOutlet weak var savignyTemperature: UILabel!
    @IBOutlet weak var savignyDescription: UILabel!

    
    @IBOutlet weak var newYorkIcon: UIImageView!
    @IBOutlet weak var newYorkTemperature: UILabel!
    @IBOutlet weak var newYorkDescription: UILabel!

    private let savignyWeatherNetworkManager = ServiceContainer.savignyWeatherNetworkManager
    private let newYorkWeatherNetworkManager = ServiceContainer.newYorkWeatherNetworkManager
    private let alertManager = ServiceContainer.alertManager

    override func viewWillAppear(_ animated: Bool) {
        savignyWeatherNetworkManager.getWeather(city: .savignyLeTemple) { (result) in
            switch result {
            case .success(let weather):
                self.displaySavignyWeather(weather: weather)
            case .failure(let error):
                self.alertManager.showErrorAlert(
                    title: "Error",
                    message: error.msg,
                    viewController: self)
            }
        }

        newYorkWeatherNetworkManager.getWeather(city: .newYork) { (result) in
            switch result {
            case .success(let weather):
                self.displayNewYorkWeather(weather: weather)
            case .failure(let error):
                self.alertManager.showErrorAlert(
                    title: "Error",
                    message: error.msg,
                    viewController: self)
            }
        }
    }

    private func displayNewYorkWeather(weather: Weather) {
        guard let newYorkIconData = weather.iconData else {
           return alertManager.showErrorAlert(title: "Error",
                message: "Invalid image data for New York weather.", viewController: self)
        }
        let iconImagenewYork = UIImage(data: newYorkIconData)
        newYorkIcon.image = iconImagenewYork
        newYorkTemperature.text = "\(Int(round(weather.temperature))) °C"
        newYorkDescription.text = weather.description
    }

    private func displaySavignyWeather(weather: Weather) {
        guard let savignyIconData = weather.iconData else {
           return alertManager.showErrorAlert(title: "Error",
                message: "Invalid image data for Savigny le temple weather.", viewController: self)
        }
        let iconImageSavigny = UIImage(data: savignyIconData)
        savignyIcon.image = iconImageSavigny
        savignyTemperature.text = "\(Int(round(weather.temperature))) °C"
        savignyDescription.text = weather.description


    }
}
