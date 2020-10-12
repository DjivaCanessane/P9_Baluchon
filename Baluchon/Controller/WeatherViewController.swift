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

    private let weatherNetworkManager = WeatherNetworkManager()
    private let alertManager = ServiceContainer.alertManager

    override func viewWillAppear(_ animated: Bool) {
        weatherNetworkManager.getWeathers { result in
            switch result {

            case .success(let weathers):
                guard let savignyWeather: Weather = weathers[.savignyLeTemple] else {
                    return self.alertManager.showErrorAlert(title: "Unable to unwrap",
                        message:"Missing Savigny le temple weather data.", viewController: self)
                }
                guard let newYorkWeather: Weather = weathers[.newYork] else {
                    return self.alertManager.showErrorAlert(title: "Error",
                        message:"Missing New York weather data.", viewController: self)
                }
                self.affectValuesToUI(savignyWeather: savignyWeather, newYorkWeather: newYorkWeather)
            case .failure(let error):
                self.alertManager.showErrorAlert(
                    title: "Error",
                    message: error.msg,
                    viewController: self)
            }
        }
    }

    private func affectValuesToUI(savignyWeather: Weather, newYorkWeather: Weather) {
        guard let savignyIconData = savignyWeather.iconData else {
           return alertManager.showErrorAlert(title: "Error",
                message: "Invalid image data for Savigny le temple weather.", viewController: self)
        }
        let iconImageSavigny = UIImage(data: savignyIconData)
        savignyIcon.image = iconImageSavigny
        savignyTemperature.text = "\(savignyWeather.temperature)"
        savignyDescription.text = savignyWeather.description

        guard let newYorkIconData = newYorkWeather.iconData else {
           return alertManager.showErrorAlert(title: "Error",
                message: "Invalid image data for New York weather.", viewController: self)
        }
        let iconImagenewYork = UIImage(data: newYorkIconData)
        newYorkIcon.image = iconImagenewYork
        newYorkTemperature.text = "\(newYorkWeather.temperature)"
        newYorkDescription.text = newYorkWeather.description
    }
}
