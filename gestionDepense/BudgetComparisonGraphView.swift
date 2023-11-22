//
//  BudgetComparisonGraphView.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 22/11/2023.
//

import SwiftUI

struct BudgetComparisonGraphView: View {
    @ObservedObject var depensesManager: DepensesManager
    @ObservedObject var userSettings: UserSettings
    var selectedMonth: Int
    var selectedYear: Int
    
    var body: some View {
        VStack {
            Text("Utilisation du Budget Mensuel")
                .font(.title3)
                .foregroundColor(.white)
                .padding()
            
            GeometryReader { geometry in
                HStack(alignment: .center, spacing: 0) {
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: calculatedWidth(for: geometry.size.width), height: 20)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: geometry.size.width - calculatedWidth(for: geometry.size.width), height: 20)
                }
                .cornerRadius(10)
                .frame(height: 20)
            }
            .frame(height: 20)
        }
        .padding()
    }
    
    private func calculatedWidth(for totalWidth: CGFloat) -> CGFloat {
        let total = depensesManager.totalDepensesPourMois(mois: selectedMonth, annee: selectedYear)
        let budget = userSettings.monthlyBudget
        let proportion = min(total / budget, 1)

        return totalWidth * CGFloat(proportion)
    }
}
