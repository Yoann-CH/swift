//
//  DonutChartView.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 22/11/2023.
//

import SwiftUI


struct DonutChartView: View {
    @ObservedObject var depensesManager: DepensesManager
    @ObservedObject var userSettings: UserSettings
    @State private var selectedCategorie: String?
    var selectedMonth: Int
    var selectedYear: Int
    @State private var pulsateImage = false
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let diameter = min(width, height)
            let radius = diameter / 2
            let center = CGPoint(x: width / 2, y: height / 2)
            let selectedDate = getDateFromMonthAndYear(month: selectedMonth, year: selectedYear)
            let data = depensesManager.dataForDonutChart(mois: selectedDate)
            
            if !data.isEmpty {
                ZStack {
                    ForEach(data, id: \.categorie) { segment in
                        DonutSegmentView(
                            center: center,
                            radius: radius + (selectedCategorie == segment.categorie ? 10 : 0),
                            startAngle: segment.startAngle,
                            endAngle: segment.endAngle,
                            color: colorForCategory(segment.categorie),
                            total: depensesManager.calculerDepensesParCategoriePourMois(mois: selectedDate)[segment.categorie] ?? 0,
                            categorie: segment.categorie,
                            selectedCategorie: selectedCategorie,
                            devise: userSettings.selectedCurrency
                        )
                        .onTapGesture {
                            self.selectedCategorie = segment.categorie
                        }
                    }
                }
                .frame(width: diameter, height: diameter)
            } else {
                VStack {
                    Image("graphe")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300, height: 300)
                        .cornerRadius(150)
                        .clipped()
                        .scaleEffect(pulsateImage ? 1.1 : 1.0)
                        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulsateImage)
                        .onAppear() {
                            self.pulsateImage = true
                        }
                    Text("Aucune dépense pour ce mois")
                        .font(.title)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding()
    }
    
    private func colorForCategory(_ category: String) -> Color {
        switch category {
        case "Nourriture":
            return Color.red
        case "Transport":
            return Color.green
        case "Loisirs":
            return Color.blue
        case "Autre":
            return Color.yellow
        default:
            return Color.black
        }
    }
    
    private func getDateFromMonthAndYear(month: Int, year: Int) -> Date {
        var components = DateComponents()
        components.month = month
        components.year = year
        components.day = 1
        return Calendar.current.date(from: components) ?? Date()
    }
}

