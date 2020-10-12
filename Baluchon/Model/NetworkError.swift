//
//  NetworkError.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 09/10/2020.
//

import Foundation

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
            return "Empty data."
        case .hasError:
            return "Contains an error."
        case .responseIsWrongType:
            return "Response format is other than HTTP."
        case .wrongStatusCode:
            return "Response's status code is not 200."
        case .canNotDecode:
            return "Error when decoding .json."
        case .wrongParsing:
            return "Error when reading decoded data."
        }
    }
}
