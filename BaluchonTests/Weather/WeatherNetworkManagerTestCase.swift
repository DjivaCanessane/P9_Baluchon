//
//  WeatherNetworkManagerTestCase.swift
//  BaluchonTests
//
//  Created by Samo Mpkamou on 19/10/2020.
//

import XCTest
@testable import Baluchon

class WeatherNetworkManagerTestCase: XCTestCase {

    func testGetWeather_ShouldPostFailedCallback_WithNetworkError_WhenSessionErrorIsNotNil() {
        injectDependencyAndShouldGetError(
            sessionData: nil,
            sessionResponse: nil,
            sessionError: FakeResponseData.error,
            expectedError: .hasError)
    }

    func testGetWeather_ShouldNotDecodeJson_WhenDataIsWrongFormat() {
        let wrongFormatData: Data? = FakeResponseData.generateData(for: "CorrectCurrency")
        injectDependencyAndShouldGetError(
            sessionData: wrongFormatData,
            sessionResponse: FakeResponseData.responseOK,
            sessionError: nil,
            expectedError: .canNotDecode)
    }

    func testGetWeather_ShouldNotParseJson_WhenDataIsCorrectFormatButDoNotContainsWeatherElement() {
        let wrongFormatData: Data? = FakeResponseData.generateData(for: "EmptyWeather")
        injectDependencyAndShouldGetError(
            sessionData: wrongFormatData,
            sessionResponse: FakeResponseData.responseOK,
            sessionError: nil,
            expectedError: .wrongParsing)
    }

    func testGetWeather_ShouldPostSuccessCallback_WithData_WhenSessionDataIsNotNilAndResponseOK() {
        // Given
        let correctData: Data? = FakeResponseData.generateData(for: "Weather")
        let networkServiceFake = NetworkService(
            networkSession: URLSessionFake(data: correctData, response: FakeResponseData.responseOK, error: nil))
        let weatherNetworkManagerFake = WeatherNetworkManager(weatherNetworkService: networkServiceFake)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherNetworkManagerFake.getWeather(city: .savignyLeTemple, callback: { result in
            switch result {
            case .success(let weatherData):
                XCTAssertEqual(weatherData.temperature, 13.37)
                XCTAssertEqual(weatherData.city, City.savignyLeTemple)
                XCTAssertEqual(weatherData.description, "broken clouds")
                XCTAssertEqual(weatherData.iconString, "04d")
                XCTAssertEqual(weatherData.iconData, nil)

            case .failure(let error): XCTFail("with error: \(error)")
            }
            expectation.fulfill()
        })
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
        let weatherNetworkManagerFake = WeatherNetworkManager(weatherNetworkService: networkServiceFake)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherNetworkManagerFake.getWeather(city: .savignyLeTemple, callback: { result in
            switch result {
            case .success(let data): XCTFail("No error, get: \(data)")
            case .failure(let error): XCTAssertEqual(error, expectedError)
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.01)
    }

}
