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
    @State private var isAnimating: Bool = false
    var selectedMonth: Int
    var selectedYear: Int
    @Binding var showTotalExpensesAlert: Bool
    
    var body: some View {
        VStack {
            Text("Utilisation du Budget Mensuel")
                .font(.title3)
                .foregroundColor(.white)
                .padding()
            
            let totalDepenses = depensesManager.totalDepensesPourMois(mois: selectedMonth, annee: selectedYear)
            let budget = userSettings.monthlyBudget
            let proportion = totalDepenses / budget
            let barColor = colorForProportion(proportion)
            
            GeometryReader { geometry in
                HStack(alignment: .center, spacing: 0) {
                    Rectangle()
                        .fill(barColor)
                        .frame(width: calculatedWidth(for: geometry.size.width, proportion: proportion), height: 20)
                        .overlay(
                            Text("\(Int(proportion * 100))%")
                                .foregroundColor(.white)
                                .padding(.leading, 10)
                        )
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: geometry.size.width - calculatedWidth(for: geometry.size.width, proportion: proportion), height: 20)
                }
                .cornerRadius(10)
                .frame(height: 20)
                .scaleEffect(isAnimating ? 1.03 : 1.0)
                .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                .onTapGesture {
                    self.showTotalExpensesAlert = true
                }
                .onAppear {
                    self.isAnimating = true
                }
            }
            .frame(height: 20)
        }
        .padding()
    }
    
    private func colorForProportion(_ proportion: Double) -> Color {
        switch proportion {
        case ...0.8:
            return Color.green
        case 0.8...1.0:
            return Color.orange
        default:
            return Color.red
        }
    }

    private func calculatedWidth(for totalWidth: CGFloat, proportion: Double) -> CGFloat {
        let clampedProportion = min(proportion, 1)
        return totalWidth * CGFloat(clampedProportion)
    }
    
    private func getDateFromMonthAndYear(month: Int, year: Int) -> Date {
        var components = DateComponents()
        components.month = month
        components.year = year
        components.day = 1
        return Calendar.current.date(from: components) ?? Date()
    }
}
