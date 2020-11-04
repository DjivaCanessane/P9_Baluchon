//
//  TranslationViewController.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 07/10/2020.
//

import UIKit

class TranslationViewController: UIViewController {
    // MARK: - PROPERTIES
    private let alertManager = ServiceContainer.alertManager
    private let translationNetworkManager = ServiceContainer.translationNetworkManager

    // MARK: - IBOUTLETS
    @IBOutlet private weak var textToTranslateView: UITextView!
    @IBOutlet private  weak var translatedTextView: UITextView!

    // MARK: - FUNCTIONS
    @IBAction func translate(_ sender: UIButton) {
        let textToTranslate: String = textToTranslateView.text
        translationNetworkManager.setTextToTranslate(text: textToTranslate)

        translationNetworkManager.getTranslation { result in
            switch result {
            case .success(let translatedText):
                self.translatedTextView.text = translatedText
            case .failure(let error):
                self.alertManager.showErrorAlert(
                    title: "Error",
                    message: error.msg,
                    viewController: self)
            }
        }
    }

    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        textToTranslateView.resignFirstResponder()
    }
}
