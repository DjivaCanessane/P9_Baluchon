//
//  FakeResponseData.swift
//  BaluchonTests
//
//  Created by Samo Mpkamou on 13/10/2020.
//

import Foundation
@testable import Baluchon

class FakeResponseData {

    // MARK: - Data
    static func generateData(for ressource: String) -> Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: ressource, withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static let incorrectData = "erreur".data(using: .utf8)!

    static let imageData = "image".data(using: .utf8)!

    static let weather = Weather(
        city: .savignyLeTemple,
        description: "broken clouds",
        temperature: 13.37,
        iconString: "04d",
        iconData: nil
    )

    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!

    // MARK: - Error
    class FakeError: Error {}
    static let error = FakeError()
}
