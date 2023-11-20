//
//  ContentView.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 20/11/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var amount: String = ""
    @State private var selectedCategory: String = "Nourriture"
    @State private var date = Date()
    @State private var isRecurring: Bool = false
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
                            .cornerRadius(150) // La moitié de la largeur et de la hauteur pour un cercle parfait
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
                // Logique pour enregistrer la dépense
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
}

struct AnimatedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



