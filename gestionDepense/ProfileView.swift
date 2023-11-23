//
//  ProfileView.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 22/11/2023.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var userSettings: UserSettings
    @State private var selectedCurrency: String = ""
    @State private var monthlyBudget: Double = 0.0
    var depensesManager: DepensesManager
    @State private var refreshID = UUID()

    var body: some View {
        Form {
            Section(header: Text("Paramètres de l'utilisateur")) {
                Picker("Devise", selection: $selectedCurrency) {
                    ForEach(userSettings.availableCurrencies, id: \.self) { currency in
                        Text(currency).tag(currency)
                    }
                }
            }
            Section(header: Text("Budget mensuel")) {
                TextField("Saisir un plafond", value: $monthlyBudget, format: .number)
                    .keyboardType(.decimalPad)
            }
            Button(action: {
                userSettings.updateMonthlyBudget(to: selectedCurrency, monthlyBudget: monthlyBudget) {
                    depensesManager.updateDepensesCurrency(to: selectedCurrency) {
                        selectedCurrency = userSettings.selectedCurrency
                        refreshID = UUID()
                    }
                }
            }) {
                Text("Enregistrer")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .buttonStyle(AnimatedButtonStyle())
        }
        .id(refreshID)
        .navigationBarTitle("Profil", displayMode: .inline)
        .onAppear {
            userSettings.fetchAvailableCurrencies {
                selectedCurrency = userSettings.selectedCurrency
                monthlyBudget = userSettings.monthlyBudget
            }
        }
    }
}
