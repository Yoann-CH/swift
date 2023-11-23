//
//  UserSettings.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 22/11/2023.
//

import Foundation
import Combine

class UserSettings: ObservableObject, Codable {
    @Published var selectedCurrency: String = "EUR" {
        didSet { saveToFile() }
    }
    @Published var availableCurrencies: [String] = []
    @Published var monthlyBudget: Double = 0.0 {
        didSet { saveToFile() }
    }
    private let apiToken = "4f1aacec62cf1b993a4d2c82"
    
    enum CodingKeys: CodingKey {
        case selectedCurrency, monthlyBudget
    }
    
    init() {
        self.loadFromFile()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        selectedCurrency = try container.decode(String.self, forKey: .selectedCurrency)
        monthlyBudget = try container.decode(Double.self, forKey: .monthlyBudget)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(selectedCurrency, forKey: .selectedCurrency)
        try container.encode(monthlyBudget, forKey: .monthlyBudget)
    }
    
    func updateUserSettings(_ userSettings: UserSettings) {
        selectedCurrency = userSettings.selectedCurrency
        monthlyBudget = userSettings.monthlyBudget
    }

    func fetchAvailableCurrencies(completion: @escaping () -> Void) {
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
                    completion()
                }
            } catch {
                print("Erreur lors du décodage des données : \(error)")
            }
        }.resume()
    }
    
    func updateMonthlyBudget(to newCurrency: String, monthlyBudget: Double, completion: @escaping () -> Void) {
        guard let url = URL(string: "https://api.exchangerate-api.com/v4/latest/\(selectedCurrency)?apikey=\(apiToken)") else {
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
                if let rate = decodedResponse.rates[newCurrency] {
                    DispatchQueue.main.async {
                        self.monthlyBudget = (monthlyBudget * rate).rounded()
                        self.selectedCurrency = newCurrency
                        completion()
                    }
                }
            } catch {
                print("Erreur lors du décodage des données : \(error)")
            }
        }.resume()
    }
    
    func saveToFile() {
        do {
            let url = getDocumentsDirectory().appendingPathComponent("UserSettings.json")
            let data = try JSONEncoder().encode(self)
            try data.write(to: url, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Impossible de sauvegarder les paramètres utilisateur: \(error)")
        }
    }

    func loadFromFile() {
        let url = getDocumentsDirectory().appendingPathComponent("UserSettings.json")
        if let data = try? Data(contentsOf: url) { // Correction ici
            if let decoded = try? JSONDecoder().decode(UserSettings.self, from: data) {
                DispatchQueue.main.async {
                    self.selectedCurrency = decoded.selectedCurrency
                    self.monthlyBudget = decoded.monthlyBudget
                }
            }
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct ExchangeRatesResponse: Decodable {
    let rates: [String: Double]
}
