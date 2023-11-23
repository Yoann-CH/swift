//
//  Depense.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 21/11/2023.
//

import SwiftUI

struct Depense: Identifiable, Equatable, Codable {
    let id = UUID()
    var montant: String
    var devise: String = "EUR"
    var categorie: String
    var date: Date
    var isRecurring: Bool
    var isFavorite: Bool = false

    static func == (lhs: Depense, rhs: Depense) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(id: UUID = UUID(), montant: String, categorie: String, date: Date, isRecurring: Bool, isFavorite: Bool = false) {
        self.montant = montant
        self.categorie = categorie
        self.date = date
        self.isRecurring = isRecurring
        self.isFavorite = isFavorite
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        montant = try container.decode(String.self, forKey: .montant)
        devise = try container.decode(String.self, forKey: .devise)
        categorie = try container.decode(String.self, forKey: .categorie)
        date = try container.decode(Date.self, forKey: .date)
        isRecurring = try container.decode(Bool.self, forKey: .isRecurring)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }
}
