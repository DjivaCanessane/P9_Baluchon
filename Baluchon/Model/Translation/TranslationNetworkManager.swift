//
//  TranslationNetworkManager.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 12/10/2020.
//

import Foundation

class TranslationNetworkManager {

    // MARK: - Internal

    // MARK: Inits

    // This init will permits to inject dependency for testing this class and send text to translate
    init(translationNetworkService: NetworkService = NetworkService()) {
        self.translationNetworkService = translationNetworkService
    }

    // MARK: Methods

    func setTextToTranslate(text: String) {
        textToTranslate = text
    }

    func getTextToTranslate() -> String {
        return self.textToTranslate
    }

    /// Returns translated text from french to english via the callback
    func getTranslation(callback: @escaping (Result<String, NetworkError>) -> Void) {

        let translationUrl = makeTranslationUrl()

        // Try to get data from the translationUrl
        translationNetworkService.getNetworkResponse(with: translationUrl) { result in
            switch result {

            // In case of failure, we pass the error to TranslationViewController callback
            case .failure(let error): callback(.failure(error))

            // In case of success, we decode the data, then we pass the rate to TranslationViewController callback
            case .success(let data):

                /* Decode the data according to type Translation,
                if not we throw an error via the callback to TranslationViewController */
                guard let decodedData = try? JSONDecoder().decode(TranslationDataStruct.self, from: data) else {
                    return callback(.failure(.canNotDecode))
                }

                /* Extract the translated text value from decodedData,
                if not we throw an error via the callback to TranslationViewController */
                guard let translatedElement = decodedData.data.translations.first else {
                    return callback(.failure(.wrongParsing))
                }

                // Send translated text via the callback
                callback(.success(translatedElement.translatedText))
            }
        }
    }
    // MARK: - Private

    // MARK: Methods

    private func makeTranslationUrl() -> URL {
        let rawURL = String(
            format: "https://translation.googleapis.com/language/translate/v2?source=fr&target=en&format=text&key=%@",
            Constants.Keys.translationKey
        )

        var translationUrl = URLComponents(
            string: rawURL
        )!
        translationUrl.queryItems?.append(URLQueryItem(name: "q", value: textToTranslate))
        return translationUrl.url!
    }

    // MARK: Properties

    private var translationNetworkService: NetworkService = NetworkService()
    private var textToTranslate: String = ""

}
