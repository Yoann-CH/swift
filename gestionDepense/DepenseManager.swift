//
//  DepenseManager.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 21/11/2023.
//

import SwiftUI

class DepensesManager: ObservableObject {
    @Published var depenses: [Depense] = []
    let categories: [String] = ["Nourriture", "Transport", "Loisirs", "Autre"]
    private var userSettings: UserSettings
    private var apiToken = "4f1aacec62cf1b993a4d2c82"
    
    init(userSettings: UserSettings) {
        self.userSettings = userSettings
    }
    
    func addDepense(_ depense: Depense) {
        var newDepense = depense
        newDepense.devise = userSettings.selectedCurrency
        depenses.append(newDepense)
    }

    func updateDepense(_ depense: Depense, at index: Int) {
        var updatedDepense = depense
        updatedDepense.devise = userSettings.selectedCurrency
        depenses[index] = updatedDepense
    }

    func deleteDepense(at indexSet: IndexSet) {
        depenses.remove(atOffsets: indexSet)
    }
    
    func calculerDepensesParCategoriePourMois(mois: Date) -> [String: Double] {
        var totalParCategorie: [String: Double] = [:]
        let calendar = Calendar.current

        for depense in depenses {
            if calendar.isDate(depense.date, equalTo: mois, toGranularity: .month) {
                let montant = Double(depense.montant) ?? 0
                totalParCategorie[depense.categorie, default: 0] += montant
            }
        }

        return totalParCategorie
    }
    
    func dataForDonutChart(mois: Date) -> [(categorie: String, startAngle: Angle, endAngle: Angle)] {
        let totalDepenses = calculerDepensesParCategoriePourMois(mois: mois).values.reduce(0, +)
        var startAngle = Angle(degrees: 0)
        var data = [(String, Angle, Angle)]()

        for categorie in categories {
            if let totalCategorie = calculerDepensesParCategoriePourMois(mois: mois)[categorie], totalCategorie > 0 {
                let proportion = totalCategorie / totalDepenses
                let endAngle = startAngle + Angle(degrees: proportion * 360)
                data.append((categorie, startAngle, endAngle))
                startAngle = endAngle
            }
        }

        return data
    }
    
    func updateDepensesCurrency(to newCurrency: String) {
        let uniqueCurrencies = Set(depenses.map { $0.devise })

        var exchangeRates = [String: Double]()

        let group = DispatchGroup()

        for currency in uniqueCurrencies {
            guard let url = URL(string: "https://api.exchangerate-api.com/v4/latest/\(currency)?apikey=\(apiToken)") else {
                print("URL invalide pour la devise \(currency)")
                continue
            }

            group.enter()
            URLSession.shared.dataTask(with: url) { data, response, error in
                defer { group.leave() }

                if let error = error {
                    print("Erreur lors de la récupération des taux de change pour \(currency) : \(error)")
                    return
                }

                guard let data = data else {
                    print("Aucune donnée reçue pour \(currency)")
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(ExchangeRatesResponse.self, from: data)
                    if let rate = decodedResponse.rates[newCurrency] {
                        exchangeRates[currency] = rate
                    }
                } catch {
                    print("Erreur lors du décodage des données pour \(currency) : \(error)")
                }
            }.resume()
        }

        group.notify(queue: .main) {
            self.applyExchangeRates(exchangeRates, to: newCurrency)
        }
    }

    private func applyExchangeRates(_ rates: [String: Double], to newCurrency: String) {
        for i in 0..<depenses.count {
            let depense = depenses[i]
            if let rate = rates[depense.devise], let oldAmount = Double(depense.montant) {
                let newAmount = oldAmount * rate
                depenses[i].montant = String(format: "%.2f", newAmount)
                depenses[i].devise = newCurrency
            }
        }
    }
    
    func totalDepensesPourMois(mois: Int, annee: Int) -> Double {
        let calendar = Calendar.current
        return depenses.reduce(0) { total, depense in
            let dateComponents = calendar.dateComponents([.year, .month], from: depense.date)
            if dateComponents.month == mois && dateComponents.year == annee {
                return total + (Double(depense.montant) ?? 0.0)
            }
            return total
        }
    }
}
