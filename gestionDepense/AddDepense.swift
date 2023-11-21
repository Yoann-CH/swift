//
//  ContentView.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 20/11/2023.
//

import SwiftUI

struct AddDepense: View {
    @Binding var depenses: [Depense]
    @State private var amount: String = ""
    @State private var selectedCategory: String = "Nourriture"
    @State private var date = Date()
    @State private var isRecurring: Bool = false
    var editingDepense: Depense?
    let categories = ["Nourriture", "Transport", "Loisirs", "Autre"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    HStack {
                        Spacer()
                        Image("depense")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 300, height: 300)
                            .cornerRadius(150)
                            .clipped()
                        Spacer()
                    }
                    formSection
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.5)]),
                    startPoint: .bottomTrailing,
                    endPoint: .topLeading
                )
            )
        }
        .onAppear {
            print("onAppear exécuté avec editingDepense: \(String(describing: editingDepense))") // Pour le débogage
            if let depense = editingDepense {
                self.amount = depense.montant
                self.selectedCategory = depense.categorie
                self.date = depense.date
                self.isRecurring = depense.isRecurring
            }
        }
        .onChange(of: editingDepense) { newValue in
            if let newDepense = newValue {
                // Mise à jour des champs de saisie
                self.amount = newDepense.montant
                self.selectedCategory = newDepense.categorie
                self.date = newDepense.date
                self.isRecurring = newDepense.isRecurring
            }
        }
    }

    var formSection: some View {
        VStack(alignment: .center, spacing: 15) {
            Text("Détails de la dépense")
                .font(.title)
                .padding(.bottom, 5)

            Group {
                TextField("Montant", text: $amount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                Divider()

                Picker("Catégorie", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { Text($0) }
                }
                .pickerStyle(SegmentedPickerStyle())
                Divider()

                DatePicker("Date", selection: $date, displayedComponents: .date)
                Divider()

                Toggle("Est une dépense récurrente", isOn: $isRecurring)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            .padding(.vertical, 4)

            Button(action: {
                if let editing = editingDepense, let index = depenses.firstIndex(where: { $0.id == editing.id }) {
                    depenses[index] = Depense(montant: amount, categorie: selectedCategory, date: date, isRecurring: isRecurring)
                } else {
                    let nouvelleDepense = Depense(montant: amount, categorie: selectedCategory, date: date, isRecurring: isRecurring)
                    depenses.append(nouvelleDepense)
                }
                resetForm()
            }) {
                Text("Enregistrer")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .padding([.horizontal, .top])
    }
    
    private func resetForm() {
        amount = ""
        selectedCategory = "Nourriture"
        date = Date()
        isRecurring = false
    }
}

struct AnimatedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}
