//
//  DepensesListView.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 21/11/2023.
//

import SwiftUI

struct DepensesListView: View {
    @ObservedObject var depensesManager: DepensesManager
    @State private var showingEditView = false
    @State private var selectedDepense: Depense?
    @State private var refreshID = UUID()
    @State private var deleteIndexSet: IndexSet?
    @State private var showingDeleteConfirmation = false
    let gradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.5)]),
        startPoint: .bottomTrailing,
        endPoint: .topLeading
    )

    var body: some View {
        NavigationView {
            ZStack {
                gradient.edgesIgnoringSafeArea(.all)
                
                if depensesManager.depenses.isEmpty {
                    VStack {
                        AnimatedImageView(name: "aucuneDepense")
                        Text("Aucune dépense")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                } else {
                    List {
                        ForEach(depensesManager.depenses) { depense in
                            HStack {
                                if depense.isFavorite {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                                VStack(alignment: .leading, spacing: 10) {
                                    let deviseSymbol = symbolForCurrencyCode(depense.devise)
                                    Text("Montant: \(depense.montant) \(deviseSymbol)")
                                    Text("Date: \(formattedDate(depense.date))")
                                    HStack(alignment: .center) {
                                        Text("Récurrente: ")
                                        Image(systemName: depense.isRecurring ? "checkmark.circle" : "xmark.circle")
                                            .resizable()
                                            .foregroundColor(depense.isRecurring ? .green : .red)
                                            .frame(width: 25, height: 25)
                                    }
                                }
                                Spacer()
                                categoryImage(for: depense.categorie)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(50)
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
                    EditDepenseView(depensesManager: depensesManager, isPresented: $showingEditView, editingDepense: depenseToEdit)
                }
            })
            .onChange(of: selectedDepense) { _ in
                refreshID = UUID()
            }
            .id(refreshID)
        }
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(
                title: Text("Supprimer la dépense"),
                message: Text("Êtes-vous sûr de vouloir supprimer cette dépense?"),
                primaryButton: .destructive(Text("Supprimer")) {
                    if let indexSet = deleteIndexSet {
                        depensesManager.deleteDepense(at: indexSet)
                    }
                },
                secondaryButton: .cancel(Text("Annuler"))
            )
        }
    }
    
    func deleteDepense(at offsets: IndexSet) {
        deleteIndexSet = offsets
        showingDeleteConfirmation = true
    }

}

func categoryImage(for category: String) -> Image {
    switch category {
    case "Nourriture":
        return Image("nourriture")
    case "Transport":
        return Image("transport")
    case "Loisirs":
        return Image("loisirs")
    case "Autre":
        return Image("autre")
    default:
        return Image(systemName: "questionmark.circle")
    }
}

func formattedDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"

    return dateFormatter.string(from: date)
}

func symbolForCurrencyCode(_ code: String) -> String {
    switch code {
    case "USD": return "$"
    case "EUR": return "€"
    case "GBP": return "£"
    case "JPY": return "¥"
    case "CAD": return "CA$"
    case "AUD": return "AU$"
    case "CNY": return "¥"
    case "INR": return "₹"
    default: return code
    }
}
