//
//  City.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 11/10/2020.
//

import Foundation

enum City: CaseIterable {
    case newYork
    case savignyLeTemple

    var name: String {
        switch self {
        case .newYork: return "New%20York"
        case .savignyLeTemple: return "Savigny-le-temple"
        }
    }
}
