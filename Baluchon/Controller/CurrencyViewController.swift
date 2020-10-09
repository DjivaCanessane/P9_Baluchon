//
//  ExchangeViewController.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 07/10/2020.
//

import UIKit

class CurrencyViewController: UIViewController {

    @IBOutlet weak var euroTextField: UITextField!
    @IBOutlet weak var dollarLabel: UILabel!

    @IBAction func convertEuroToDollar(_ sender: UIButton) {
        guard let montantEuroString = euroTextField.text else {
            showErrorAlert(title: "Entrez un montant",
                           message: "Vous n'avez insérer aucun montant à convertir, veuilez en saisir une.")
            return
        }
        CurrencyService.shared.getCurrency { result in
            switch result {
            case .success(let rate):
                guard let montantEuro = Double(montantEuroString) else {
                    print("erreur")
                    return
                }
                let montantDollar: Double = montantEuro * rate
                self.dollarLabel.text = "\(montantDollar)"
            case .failure(let error):
                self.showErrorAlert(title: "Problème",
                                    message: error.msg)
            }
        }
    }

    func showErrorAlert(title: String, message: String) {
        let alertVC =
            UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

}
