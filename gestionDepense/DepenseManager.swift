//
//  DepenseManager.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 21/11/2023.
//

import SwiftUI

class DepensesManager: ObservableObject {
    @Published var depenses: [Depense] = []
    
    func addDepense(_ depense: Depense) {
        depenses.append(depense)
    }

    func updateDepense(_ depense: Depense, at index: Int) {
        depenses[index] = depense
    }

    func deleteDepense(at indexSet: IndexSet) {
        depenses.remove(atOffsets: indexSet)
    }
    
}
