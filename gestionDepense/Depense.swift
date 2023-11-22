//
//  Depense.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 21/11/2023.
//

import SwiftUI

struct Depense: Identifiable, Equatable {
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
}
