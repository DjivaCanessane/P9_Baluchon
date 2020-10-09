//
//  ExchangeRateService.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 08/10/2020.
//

import Foundation

class CurrencyService {
    static var shared = CurrencyService()
    //private init() { }
    private let currencyUrl =
        URL(string: "http://data.fixer.io/api/latest?access_key=8a723bc2a0abfe44b592ecaf54ae89f9&base=EUR&symbols=USD")!

    private var currencySession: URLSession

    init(currencySession: URLSession = URLSession(configuration: .default)) {
        self.currencySession = currencySession
    }

    private var task: URLSessionDataTask?

    func getCurrency(callback: @escaping (Result<Double, NetworkError>) -> Void) {

        task?.cancel()
        task = currencySession.dataTask(with: currencyUrl) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    return callback(.failure(.noData))
                }

                guard error == nil else {
                    return callback(.failure(.hasError))
                }

                guard let response = response as? HTTPURLResponse else {
                    return callback(.failure(.responseIsWrongType))
                }

                guard response.statusCode == 200 else {
                    return callback(.failure(.wrongStatusCode))
                }

                guard let responseJSON = try? JSONDecoder().decode(Currency.self, from: data) else {
                    return callback(.failure(.canNotDecode))
                }

                guard let rate = responseJSON.rates["USD"] else {
                    return callback(.failure(.wrongParsing))
                }

                callback(.success(rate))
            }
        }
        task?.resume()
    }
}

enum NetworkError: Error {
    case noData
    case hasError
    case responseIsWrongType
    case wrongStatusCode
    case canNotDecode
    case wrongParsing

    var msg: String {
        switch self {
        case .noData:
            return "Aucune données"
        case .hasError:
            return "Contient une erreur"
        case .responseIsWrongType:
            return "La réponse n'espas du format HTTP"
        case .wrongStatusCode:
            return "Le code du statut est différent de 200"
        case .canNotDecode:
            return "Erreur de décodage du .json"
        case .wrongParsing:
            return "Erreur de lecture du .json"
        }
    }
}
