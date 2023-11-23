//
//  DonutChartView.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 22/11/2023.
//

import SwiftUI

struct ChartView: View {
    @ObservedObject var depensesManager: DepensesManager
    @ObservedObject var userSettings: UserSettings
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var refreshID = UUID()
    @State private var selectedCategorie: String?
    @State var showTotalExpensesAlert: Bool = false
    let gradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.5)]),
        startPoint: .bottomTrailing,
        endPoint: .topLeading
    )

    var body: some View {
        NavigationView {
            ZStack {
                gradient.edgesIgnoringSafeArea(.all)
                                    
                if !depensesManager.depenses.isEmpty {
                    VStack {
                        Text(titreDuMoisEtAnnee())
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                        
                        selectMonthAndYear
                        
                        if userSettings.monthlyBudget > 0 && depensesManager.totalDepensesPourMois(mois: selectedMonth, annee: selectedYear) > 0 {
                            BudgetComparisonGraphView(depensesManager: depensesManager, userSettings: userSettings, selectedMonth: selectedMonth, selectedYear: selectedYear, showTotalExpensesAlert: $showTotalExpensesAlert)
                        }
                        
                        DonutChartView(depensesManager: depensesManager, userSettings: userSettings, selectedCategorie: $selectedCategorie, selectedMonth: selectedMonth, selectedYear: selectedYear)
                    }
                } else {
                    VStack {
                        Text("Aucune dépense")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
            }
            .id(refreshID)
            .onAppear {
                refreshID = UUID()
                selectedCategorie = nil
            }
            .onTapGesture {
                if selectedCategorie != nil {
                    selectedCategorie = nil
                }
            }
        }
        .overlay(
            showTotalExpensesAlert ? fullScreenOverlay : nil
        )
    }

    private var selectMonthAndYear: some View {
        var frenchCalendar = Calendar.current
        frenchCalendar.locale = Locale(identifier: "fr_FR")
        
        return HStack {
    
            Picker("Mois", selection: $selectedMonth) {
                ForEach(1...12, id: \.self) { month in
                    Text(frenchCalendar.monthSymbols[month - 1]).tag(month)
                }
            }
            .pickerStyle(MenuPickerStyle())

            Picker("Année", selection: $selectedYear) {
                ForEach(2000...2035, id: \.self) { year in
                    Text(String(year)).tag(year)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .padding()
    }
    
    private func titreDuMoisEtAnnee() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: getDateFromMonthAndYear(month: selectedMonth, year: selectedYear)).capitalized
    }
    
    var fullScreenOverlay: some View {
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.6))
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { self.showTotalExpensesAlert = false }

            CustomAlertView(
                title: "Dépenses Totales",
                message: "Le total des dépenses pour \(monthName(selectedMonth)) est de \(formattedTotalExpenses()) \(userSettings.selectedCurrency)",
                primaryButtonText: "Ok",
                primaryButtonAction: { self.showTotalExpensesAlert = false }
            )
        }
        .transition(.scale)
    }
    
    private func monthName(_ month: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "MMMM yyyy"
        let date = getDateFromMonthAndYear(month: month, year: selectedYear)
        return dateFormatter.string(from: date)
    }

    private func formattedTotalExpenses() -> String {
        let total = depensesManager.totalDepensesPourMois(mois: selectedMonth, annee: selectedYear)
        return String(format: "%.2f", total)
    }

}

private func getDateFromMonthAndYear(month: Int, year: Int) -> Date {
    var components = DateComponents()
    components.month = month
    components.year = year
    components.day = 1
    return Calendar.current.date(from: components) ?? Date()
}
