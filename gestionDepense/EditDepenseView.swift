//
//  ContentView.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 20/11/2023.
//

import SwiftUI

struct EditDepenseView: View {
    @ObservedObject var depensesManager: DepensesManager
    @Binding var isPresented: Bool
    @State private var amount: String = ""
    @State private var selectedCategory: String = "Nourriture"
    @State private var date = Date()
    @State private var isRecurring: Bool = false
    @State private var animate: Bool = false
    @State private var showNotification = false
    @State private var isAmountValid: Bool = true
    var editingDepense: Depense?
    let categories: [String] = ["Nourriture", "Transport", "Loisirs", "Autre"]
    var rotationDegrees: Double {
        animate ? 10 : -10
    }
    var validatedAmount: Binding<String> {
        Binding<String>(
            get: { self.amount },
            set: {
                if $0.isEmpty || Double($0) != nil {
                    self.amount = $0
                    self.isAmountValid = true
                } else {
                    self.isAmountValid = false
                }
            }
        )
    }

    var body: some View {
        ZStack {
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
                                .rotation3DEffect(Angle(degrees: rotationDegrees), axis: (x: 0, y: 1, z: 0))
                                .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animate)
                                .onAppear() {
                                    self.animate = true
                                }
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
                if let depense = editingDepense {
                    self.amount = depense.montant
                    self.selectedCategory = depense.categorie
                    self.date = depense.date
                    self.isRecurring = depense.isRecurring
                }
            }

            GeometryReader { geometry in
                if showNotification {
                    NotificationView()
                        .position(x: geometry.size.width - 110, y: 40)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showNotification = false
                            }
                        }
                }
            }
        }
    }


    var formSection: some View {
        VStack(alignment: .center, spacing: 15) {
            if editingDepense != nil {
                Text("Détails de la dépense")
                    .font(.title)
                    .padding(.bottom, 5)
            } else {
                Text("Ajouter une dépense")
                    .font(.title)
                    .padding(.bottom, 5)
            }

            Group {
                TextField("Montant", text: validatedAmount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                if !isAmountValid {
                    Text("Veuillez entrer un montant valide")
                        .foregroundColor(.red)
                }
                
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
                guard !amount.isEmpty, let _ = Double(amount) else {
                    isAmountValid = false
                    return
                }
                if let editing = editingDepense, let index = depensesManager.depenses.firstIndex(where: { $0.id == editing.id }) {
                    depensesManager.updateDepense(Depense(montant: amount, categorie: selectedCategory, date: date, isRecurring: isRecurring), at: index)
                } else {
                    let nouvelleDepense = Depense(montant: amount, categorie: selectedCategory, date: date, isRecurring: isRecurring)
                    depensesManager.addDepense(nouvelleDepense)
                }
                resetForm()
                isPresented = false
                isAmountValid = true
                showNotification = true
            }) {
                if editingDepense != nil {
                    Text("Modifier")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                } else {
                    Text("Enregistrer")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
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
