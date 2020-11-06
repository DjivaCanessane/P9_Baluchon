//  NetworkService.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 09/10/2020.
//

import Foundation

class NetworkService {
    // MARK: - PROPERTIES
    private var networkSession: URLSession

    // MARK: - FUNCTIONS
    // MARK: Internal
    // This init will permits to inject dependency for testing this class
    init(networkSession: URLSession = URLSession(configuration: .default)) {
        self.networkSession = networkSession
    }

    /// Method get and send undecoded json data or error via callback
    func getNetworkResponse(with targetURL: URL, callback: @escaping (Result<Data, NetworkError>) -> Void) {

        // Avoid parallel network calls
        var task: URLSessionDataTask?
        task = networkSession.dataTask(with: targetURL) { (data, response, error) in

            // Putting code execution in main thread to ensure coordianation with UI
            DispatchQueue.main.async {

                // Ensure that network call return an empty error, else we send an error via callback
                guard error == nil else {
                    return callback(.failure(.hasError))
                }

                // Ensure that network call return a correct response format, else we send an error via callback
                guard let response = response as? HTTPURLResponse else {
                    return callback(.failure(.responseIsWrongType))
                }

                // Ensure that network call return a response status code 200, else we send an error via callback
                guard response.statusCode == 200 else {
                    return callback(.failure(.wrongStatusCode))
                }

                // Ensure that network call return a not empty data, else we send an error via callback
                guard let data = data else {
                    return callback(.failure(.noData))
                }

                // Finally, if all conditions passed, we send uncoded data wia the callback
                callback(.success(data))

            }
        }
        task?.resume()
    }
}
