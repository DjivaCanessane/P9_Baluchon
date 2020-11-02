//
//  WeatherIconNetworkManagerTestCase.swift
//  BaluchonTests
//
//  Created by Djiveradjane Canessane on 30/10/2020.
//

import XCTest
@testable import Baluchon

class WeatherIconNetworkManagerTestCase: XCTestCase {

    func testGetIconData_ShouldPostSuccessCallback_WithIconData_WhenSessionDataIsNotNilAndResponseOK() {
        // Given
        let weather: Weather = FakeResponseData.weather
        let iconData = FakeResponseData.imageData
        let networkServiceFake = NetworkService(
            networkSession: URLSessionFake(data: iconData, response: FakeResponseData.responseOK, error: nil))
        let weatherIconNetworkManagerFake = WeatherIconNetworkManager(weatherIconNetworkService: networkServiceFake)
        // When

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherIconNetworkManagerFake.getIconData(weather: weather, callback: { result in
            switch result {
            case .success(let weatherData):
                XCTAssertEqual(weatherData.temperature, 13.37)
                XCTAssertEqual(weatherData.city, City.savignyLeTemple)
                XCTAssertEqual(weatherData.description, "broken clouds")
                XCTAssertEqual(weatherData.iconString, "04d")
                XCTAssertEqual(weatherData.iconData, FakeResponseData.imageData)

            case .failure(let error): XCTFail("with error: \(error)")
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetIconData_ShouldPostSuccessCallback_WithWrongData_WhenSessionDataIsIncorrectAndResponseOK() {
        // Given
        let weather: Weather = FakeResponseData.weather
        let iconData = FakeResponseData.incorrectData
        let networkServiceFake = NetworkService(
            networkSession: URLSessionFake(data: iconData, response: FakeResponseData.responseOK, error: nil))
        let weatherIconNetworkManagerFake = WeatherIconNetworkManager(weatherIconNetworkService: networkServiceFake)
        // When

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherIconNetworkManagerFake.getIconData(weather: weather, callback: { result in
            switch result {
            case .success(let weatherData):
                XCTAssertFalse(weatherData.iconData == FakeResponseData.imageData)

            case .failure(let error): XCTFail("with error: \(error)")
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetIconData_ShouldPostFailureCallback_WithError_WhenSessionDataIsNotNilAndResponseOK() {
        // Given
        let weather: Weather = FakeResponseData.weather
        let networkServiceFake = NetworkService(
            networkSession: URLSessionFake(data: nil, response: FakeResponseData.responseOK, error: nil))
        let weatherIconNetworkManagerFake = WeatherIconNetworkManager(weatherIconNetworkService: networkServiceFake)
        // When

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherIconNetworkManagerFake.getIconData(weather: weather, callback: { result in
            switch result {
            case .success(let weatherData):
                XCTFail("with data: \(weatherData)")

            case .failure(let error): XCTAssertEqual(error, NetworkError.noData)
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.01)
    }

}
