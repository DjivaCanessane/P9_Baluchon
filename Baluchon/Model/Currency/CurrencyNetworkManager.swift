//  ExchangeRateService.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 08/10/2020.
//

import Foundation

class CurrencyNetworkManager {
    // MARK: - PROPERTIES
    private var currencyNetworkService: NetworkService = NetworkService()
    private let currencyUrl =
        URL(string: "http://data.fixer.io/api/latest?access_key=\(Constants.Keys.currencyKey)&base=EUR&symbols=USD")!

    // MARK: - FUNCTIONS
    // MARK: Internal
    // This init will permits to inject dependency for testing this class
    init(currencyNetworkService: NetworkService = NetworkService()) {
        self.currencyNetworkService = currencyNetworkService
    }

    /// Returns the actual currency exchange rate of EUR/USD via the callback
    func getCurrency(callback: @escaping (Result<Double, NetworkError>) -> Void) {
        // Try to get data from the currencyUrl
        currencyNetworkService.getNetworkResponse(with: currencyUrl) { result in
            switch result {

            // In case of failure, we pass the error to CurrencyViewController callback
            case .failure(let error): callback(.failure(error))

            // In case of success, we decode the data, then we pass the rate to CurrencyViewController callback
            case .success(let data):

                /* Decode the data according to type Currency,
                if not we throw an error via the callback to CurrencyViewController */
                guard let decodedData = try? JSONDecoder().decode(CurrencyDataStruct.self, from: data) else {
                    return callback(.failure(.canNotDecode))
                }

                /* Extract the rate value from decodedData,
                if not we throw an error via the callback to CurrencyViewController */
                guard let rate = decodedData.rates["USD"] else {
                    return callback(.failure(.wrongParsing))
                }

                // Send the actual currency exchange rate of EUR/USD via the callback
                callback(.success(rate))
            }
        }
    }
}
