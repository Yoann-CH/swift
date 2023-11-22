//
//  UserSettings.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 22/11/2023.
//

import Foundation
import Combine

class UserSettings: ObservableObject {
    @Published var selectedCurrency: String = "EUR"
    @Published var availableCurrencies: [String] = []
    @Published var monthlyBudget: Double = 0.0

    private let apiToken = "4f1aacec62cf1b993a4d2c82"

    func fetchAvailableCurrencies() {
        guard let url = URL(string: "https://api.exchangerate-api.com/v4/latest/EUR?apikey=\(apiToken)") else {
            print("URL invalide")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erreur lors de la récupération des données : \(error)")
                return
            }

            guard let data = data else {
                print("Aucune donnée reçue")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(ExchangeRatesResponse.self, from: data)
                DispatchQueue.main.async {
                    self.availableCurrencies = Array(decodedResponse.rates.keys).sorted()
                }
            } catch {
                print("Erreur lors du décodage des données : \(error)")
            }
        }.resume()
    }
}

struct ExchangeRatesResponse: Decodable {
    let rates: [String: Double]
}
