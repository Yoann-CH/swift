//
//  DepensesListView.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 21/11/2023.
//

import SwiftUI

struct DepensesListView: View {
    @Binding var depenses: [Depense]
    @State private var showingEditView = false
    @State private var selectedDepense: Depense? = nil
    let gradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.5)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        NavigationView {
            ZStack {
                gradient.edgesIgnoringSafeArea(.all)
                
                if depenses.isEmpty {
                    VStack {
                        Image("aucuneDepense")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(150)
                            .foregroundColor(.white)
                        Text("Aucune dépense")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                } else {
                    List {
                        ForEach(depenses) { depense in
                            VStack(alignment: .leading) {
                                Text("Montant: \(depense.montant)")
                                Text("Catégorie: \(depense.categorie)")
                                Text("Date: \(formattedDate(depense.date))")
                                Text("Récurrente: \(depense.isRecurring ? "Oui" : "Non")")
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    selectedDepense = depense
                                    showingEditView = true
                                } label: {
                                    Label("Modifier", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
                            .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: deleteDepense)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .sheet(isPresented: $showingEditView, content: {
                if let depenseToEdit = selectedDepense {
                    AddDepense(depenses: $depenses, editingDepense: depenseToEdit)
                }
            })
        }
    }
    
    func deleteDepense(at offsets: IndexSet) {
        depenses.remove(atOffsets: offsets)
    }
}

func formattedDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"

    return dateFormatter.string(from: date)
}
