//
//  TranslationNetworkManagerTestCase.swift
//  BaluchonTests
//
//  Created by Samo Mpkamou on 15/10/2020.
//

import XCTest
@testable import Baluchon

class TranslationNetworkManagerTestCase: XCTestCase {
    func testGetTranslation_ShouldPostFailedCallback_WithNetworkError_WhenSessionErrorIsNotNil() {
        injectDependencyAndShouldGetError(
            sessionData: nil,
            sessionResponse: nil,
            sessionError: FakeResponseData.error,
            expectedError: .hasError)
    }

    func testGetTranslation_ShouldNotDecodeJson_WhenDataIsWrongFormat() {
        let wrongFormatData: Data? = FakeResponseData.generateData(for: "CorrectCurrency")
        injectDependencyAndShouldGetError(
            sessionData: wrongFormatData,
            sessionResponse: FakeResponseData.responseOK,
            sessionError: nil,
            expectedError: .canNotDecode)
    }

    func testGetTranslation_ShouldNotParseJson_WhenDataIsCorrupted() {
        let wrongFormatData: Data? = FakeResponseData.generateData(for: "WrongTranslation")
        injectDependencyAndShouldGetError(
            sessionData: wrongFormatData,
            sessionResponse: FakeResponseData.responseOK,
            sessionError: nil,
            expectedError: .wrongParsing)
    }

    func testGetTranslation_ShouldPostSuccessCallback_WithData_WhenSessionDataIsNotNilAndResponseOK() {
        // Given
        let correctData: Data? = FakeResponseData.generateData(for: "Translation")
        let networkServiceFake = NetworkService(
            networkSession: URLSessionFake(data: correctData, response: FakeResponseData.responseOK, error: nil))
        let translationNetworkManagerFake = TranslationNetworkManager(translationNetworkService: networkServiceFake)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationNetworkManagerFake.getTranslation(callback: { result in
            switch result {
            case .success(let translatedText): XCTAssertEqual(translatedText, "Hello")
            case .failure(let error): XCTFail("with error: \(error)")
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.01)
    }

    func testSetTextToTranslate_ShouldModifyTextToTranslate_WhenGiveNewText() {
        let translationNetworkManager = TranslationNetworkManager()
        translationNetworkManager.setTextToTranslate(text: "Coucou")
        XCTAssertEqual(translationNetworkManager.getTextToTranslate(), "Coucou")
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
        let translationNetworkManagerFake = TranslationNetworkManager(translationNetworkService: networkServiceFake)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationNetworkManagerFake.getTranslation(callback: { result in
            switch result {
            case .success(let rate): XCTFail("No error, get: \(rate)")
            case .failure(let error): XCTAssertEqual(error, expectedError)
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.01)
    }

}
