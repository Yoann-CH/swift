//
//  ProfileView.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 22/11/2023.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var userSettings: UserSettings
    var depensesManager: DepensesManager

    var body: some View {
        Form {
            Section(header: Text("Paramètres de l'utilisateur")) {
                Picker("Devise", selection: $userSettings.selectedCurrency) {
                    ForEach(userSettings.availableCurrencies, id: \.self) { currency in
                        Text(currency).tag(currency)
                    }
                }
            }
            Section(header: Text("Budget mensuel")) {
                TextField("Saisir un plafond", value: $userSettings.monthlyBudget, format: .number)
                    .keyboardType(.decimalPad)
            }
            Button(action: {
                depensesManager.updateDepensesCurrency(to: userSettings.selectedCurrency)
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
        .navigationBarTitle("Profil", displayMode: .inline)
        .onAppear {
            userSettings.fetchAvailableCurrencies()
        }
    }
}
