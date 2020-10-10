//
//  AlertDialog.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 10/10/2020.
//

import UIKit

class AlertVC {
    func showErrorAlert(title: String, message: String, viewController: UIViewController) {
        let alertVC =
            UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController.present(alertVC, animated: true, completion: nil)
    }
}
