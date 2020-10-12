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
    init(textToTranslate: String = "", translationSession: URLSession = URLSession(configuration: .default)) {
        self.translationSession = translationSession
        self.textToTranslate = textToTranslate
    }



    // MARK: Methods

    func setTextToTranslate(text: String) {
        textToTranslate = text
    }

    /// Returns translated text from french to english via the callback
    func getTranslation(callback: @escaping (Result<String, NetworkError>) -> Void) {

        guard let translationUrl = makeTransalationUrl() else {
            return callback(.failure(.invalidURL))
        }
        // Try to get data from the translationUrl
        translationNetworkService.getNetworkResponse(with: translationUrl) { result in
            switch result {

            // In case of failure, we pass the error to TranslationViewController callback
            case .failure(let error): callback(.failure(error))

            // In case of success, we decode the data, then we pass the rate to TranslationViewController callback
            case .success(let data):

                /* Decode the data according to type Translation,
                if not we throw an error via the callback to TranslationViewController */
                guard let decodedData = try? JSONDecoder().decode(Translation.self, from: data) else {
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

    private func makeTransalationUrl() -> URL? {
        var translationUrl = URLComponents(
            string: "https://translation.googleapis.com/language/translate/v2?source=fr&target=en&format=text&key=\(TRANSLATION_KEY)")!
        translationUrl.queryItems?.append(URLQueryItem(name: "q", value: textToTranslate))
        return translationUrl.url
    }
    // MARK: Properties

    private var translationSession: URLSession
    private var task: URLSessionDataTask?

    private let translationNetworkService: NetworkService = NetworkService()
    private var textToTranslate: String = ""

}
