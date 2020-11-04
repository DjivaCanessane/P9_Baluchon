//  ExchangeViewController.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 07/10/2020.
//

import UIKit

class CurrencyViewController: UIViewController {
    // MARK: - PROPERTIES
    private let currencyNetworkManager = ServiceContainer.currencyNetworkManager
    private let alertManager = ServiceContainer.alertManager

    // MARK: - IBOUTLETS
    @IBOutlet private weak var euroTextField: UITextField!
    @IBOutlet private weak var dollarLabel: UILabel!

    // MARK: - FUNCTIONS
    /// Update dollarLabel with the converted amount  from euroTextField
    @IBAction private func convertEuroToDollar(_ sender: UIButton) {

        // Unwrap euroTextField text, else we show an error alert
        guard let euroAmountString: String = euroTextField.text else {
            return alertManager.showErrorAlert(
                title: "Insert an amount",
                message: "Please insert an amount with the numeric pad.",
                viewController: self
            )
        }

        // Get in time currency exchange rate
        currencyNetworkManager.getCurrency { result in
            switch result {

            // Case of success we convert Euros to Dollars and update dollarLabel
            case .success(let rate):

                // Convert String to Double, else we show an alert error
                guard let euroAmountDouble = Double(euroAmountString) else {
                    return self.alertManager.showErrorAlert(title: "Error",
                    message: "Can not convert string into double.", viewController: self)
                }

                // Calculate dollar amount from euro amount
                let dollarAmount: Double = euroAmountDouble * rate
                // Round dollarAmount to cents
                let roundedDollarAmount: Double = Double(round(dollarAmount * 100)/100)

                // Update dollarLabel
                self.dollarLabel.text = "\(roundedDollarAmount)"

            // Case of failure, we show an error alert
            case .failure(let error):
                self.alertManager.showErrorAlert(title: "Error",
                    message: error.msg, viewController: self)
            }
        }
    }

    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        euroTextField.resignFirstResponder()
    }
}
