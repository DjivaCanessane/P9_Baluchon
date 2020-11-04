//
//  NetworkManagerTestCase.swift
//  BaluchonTests
//
//  Created by Samo Mpkamou on 15/10/2020.
//

import XCTest
@testable import Baluchon

class NetworkManagerTestCase: XCTestCase {
    // MARK: - Tests
    func testGetNetworkResponse_ShouldPostFailedCallback_WithHasError_WhenSessionErrorIsNotNil() {
        injectDependencyAndShouldGetError(
            sessionData: nil,
            sessionResponse: nil,
            sessionError: FakeResponseData.error,
            expectedError: .hasError)
    }

    func testGetNetworkResponse_ShouldPostFailedCallback_WithResponseHasWrongType_WhenSessionResponseIsNotNil() {
        injectDependencyAndShouldGetError(
            sessionData: nil,
            sessionResponse: nil,
            sessionError: nil,
            expectedError: .responseIsWrongType)
    }

    func testGetNetworkResponse_ShouldPostFailedCallback_WithWrongStatusCode_WhenSessionResponseStatusCodeIsNot200() {
        injectDependencyAndShouldGetError(
            sessionData: nil,
            sessionResponse: FakeResponseData.responseKO,
            sessionError: nil,
            expectedError: .wrongStatusCode)
    }

    func testGetNetworkResponse_ShouldPostFailedCallback_WithNoData_WhenSessionDataIsNil() {
        injectDependencyAndShouldGetError(
            sessionData: nil,
            sessionResponse: FakeResponseData.responseOK,
            sessionError: nil,
            expectedError: .noData)
    }

    func testGetNetworkResponse_ShouldPostSuccessCallback_WithData_WhenSessionDataIsNotNilAndResponseOK() {
        // Given
        let networkServiceFake = NetworkService(
            networkSession: URLSessionFake(
                data: FakeResponseData.imageData,
                response: FakeResponseData.responseOK,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        networkServiceFake.getNetworkResponse(with: URL(string: "https://openclassrooms.com")!) { result in
            switch result {
            case .success(let data): XCTAssertEqual(data, FakeResponseData.imageData)
            case .failure(let error): XCTFail("Has error: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    // MARK: - PRIVATE FUNCTIONS
    private func injectDependencyAndShouldGetError(
        sessionData: Data?,
        sessionResponse: HTTPURLResponse?,
        sessionError: Error?,
        expectedError: NetworkError) {
        // Given
        let networkServiceFake = NetworkService(
            networkSession: URLSessionFake(data: sessionData, response: sessionResponse, error: sessionError))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        networkServiceFake.getNetworkResponse(with: URL(string: "https://openclassrooms.com")!) { result in
            switch result {
            case .success(let data): XCTFail("No error, get: \(data)")
            case .failure(let error): XCTAssertEqual(error, expectedError)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
