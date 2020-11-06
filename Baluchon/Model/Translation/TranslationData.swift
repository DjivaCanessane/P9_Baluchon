//
//  TranslationData.swift
//  Baluchon
//
//  Created by Samo Mpkamou on 12/10/2020.
//

import Foundation

// MARK: - Translation
struct TranslationData: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let translations: [TranslationElement]
}

// MARK: - TranslationElement
struct TranslationElement: Codable {
    let translatedText: String
}
