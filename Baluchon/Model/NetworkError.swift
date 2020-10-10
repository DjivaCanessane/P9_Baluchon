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
            return "Aucune données"
        case .hasError:
            return "Contient une erreur"
        case .responseIsWrongType:
            return "La réponse n'espas du format HTTP"
        case .wrongStatusCode:
            return "Le code du statut est différent de 200"
        case .canNotDecode:
            return "Erreur de décodage du .json"
        case .wrongParsing:
            return "Erreur de lecture du .json"
        }
    }
}
