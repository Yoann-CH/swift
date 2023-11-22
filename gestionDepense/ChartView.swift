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
                            BudgetComparisonGraphView(depensesManager: depensesManager, userSettings: userSettings, selectedMonth: selectedMonth, selectedYear: selectedYear)
                        }
                        
                        DonutChartView(depensesManager: depensesManager, userSettings: userSettings, selectedMonth: selectedMonth, selectedYear: selectedYear)
                    }
                } else {
                    VStack {
                        Text("Aucune dépense")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
            }
        }
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

}

private func getDateFromMonthAndYear(month: Int, year: Int) -> Date {
    var components = DateComponents()
    components.month = month
    components.year = year
    components.day = 1
    return Calendar.current.date(from: components) ?? Date()
}

private func iconForCategory(_ category: String) -> Image {
    switch category {
    case "Nourriture":
        return Image(systemName: "fork.knife")
    case "Transport":
        return Image(systemName: "car")
    case "Loisirs":
        return Image(systemName: "gamecontroller")
    case "Autre":
        return Image(systemName: "square.and.pencil")
    default:
        return Image(systemName: "questionmark.circle")
    }
}


struct DonutSegmentView: View {
    var center: CGPoint
    var radius: CGFloat
    var startAngle: Angle
    var endAngle: Angle
    var color: Color
    var total: Double
    var categorie: String
    var selectedCategorie: String?
    var devise: String
    var isSelected: Bool {
        selectedCategorie == categorie
        
    }
    var midAngle: Angle {
        Angle(degrees: (startAngle.degrees + endAngle.degrees) / 2)
    }

    var body: some View {
        ZStack {
            Path { path in
                path.move(to: center)
                path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            }
            .fill(color)
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.easeInOut, value: isSelected)



            if selectedCategorie == categorie {
                let deviseSymbol = symbolForCurrencyCode(devise)
                Text("\(total, specifier: "%.2f") \(deviseSymbol)")
                    .foregroundColor(.white)
                    .position(
                        x: center.x + cos(midAngle.radians) * (radius + 10) / 2,
                        y: center.y + sin(midAngle.radians) * (radius + 10) / 2
                    )
            } else {
                iconForCategory(categorie)
                    .foregroundColor(.white)
                    .position(
                        x: center.x + cos(midAngle.radians) * radius / 2,
                        y: center.y + sin(midAngle.radians) * radius / 2
                    )
            }
        }
    }
}
