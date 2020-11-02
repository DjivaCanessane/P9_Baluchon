//  CurrencyNetworkManagerTestCase.swift
//  BaluchonTests
//
//  Created by Samo Mpkamou on 14/10/2020.
//

import XCTest
@testable import Baluchon

class CurrencyNetworkManagerTestCase: XCTestCase {

    func testGetCurrency_ShouldPostFailedCallback_WithNetworkError_WhenSessionErrorIsNotNil() {
        injectDependencyAndShouldGetError(
            sessionData: nil,
            sessionResponse: nil,
            sessionError: FakeResponseData.error,
            expectedError: .hasError)
    }

    func testGetCurrency_ShouldNotDecodeJson_WhenDataIsWrongFormat() {
        let wrongFormatData: Data? = FakeResponseData.generateData(for: "Translation")
        injectDependencyAndShouldGetError(
            sessionData: wrongFormatData,
            sessionResponse: FakeResponseData.responseOK,
            sessionError: nil,
            expectedError: .canNotDecode)
    }

    func testGetCurrency_ShouldParseJson_WhenDataIsCorrectFormatButDoNotContainsUSDExchangeRateToEUR() {
        let wrongFormatData: Data? = FakeResponseData.generateData(for: "CurrencyWithWrongExchageRate")
        injectDependencyAndShouldGetError(
            sessionData: wrongFormatData,
            sessionResponse: FakeResponseData.responseOK,
            sessionError: nil,
            expectedError: .wrongParsing)
    }

    func testGetCurrency_ShouldPostSuccessCallback_WithData_WhenSessionDataIsNotNilAndResponseOK() {
        // Given
        let correctData: Data? = FakeResponseData.generateData(for: "CorrectCurrency")
        let networkServiceFake = NetworkService(
            networkSession: URLSessionFake(data: correctData, response: FakeResponseData.responseOK, error: nil))
        let currencyNetworkManagerFake = CurrencyNetworkManager(currencyNetworkService: networkServiceFake)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyNetworkManagerFake.getCurrency(callback: { result in
            switch result {
            case .success(let rate): XCTAssertEqual(rate, 1.17544, accuracy: 0.00001)
            case .failure(let error): XCTFail("with error: \(error)")
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.01)
    }

    // MARK: - Private
    // MARK: Methods

    private func injectDependencyAndShouldGetError(
        sessionData: Data?,
        sessionResponse: HTTPURLResponse?,
        sessionError: Error?,
        expectedError: NetworkError) {
        // Given
        let networkServiceFake = NetworkService(
            networkSession: URLSessionFake(data: sessionData, response: sessionResponse, error: sessionError))
        let currencyNetworkManagerFake = CurrencyNetworkManager(currencyNetworkService: networkServiceFake)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyNetworkManagerFake.getCurrency(callback: { result in
            switch result {
            case .success(let rate): XCTFail("No error, get: \(rate)")
            case .failure(let error): XCTAssertEqual(error, expectedError)
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.01)
    }
}
