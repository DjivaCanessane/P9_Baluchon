//
//  FakeResponseData.swift
//  BaluchonTests
//
//  Created by Samo Mpkamou on 13/10/2020.
//

import Foundation
@testable import Baluchon

class FakeResponseData {
    // MARK: - DATA
    static let incorrectData = "erreur".data(using: .utf8)!
    static let imageData = "image".data(using: .utf8)!
    static let weather = Weather(
        city: .savignyLeTemple,
        description: "broken clouds",
        temperature: 13.37,
        iconString: "04d",
        iconData: nil
    )

    static func generateData(for ressource: String) -> Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: ressource, withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    // MARK: - RESPONSE
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!

    // MARK: - ERROR
    class FakeError: Error {}
    static let error = FakeError()
}
