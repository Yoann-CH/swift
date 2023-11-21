//
//  MainView.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 21/11/2023.
//

import SwiftUI

struct MainView: View {
    @State private var depenses = [Depense]()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            AddDepense(depenses: $depenses)
                .tabItem {
                    Label("Ajouter", systemImage: "plus.circle")
                }
                .tag(0)

            DepensesListView(depenses: $depenses)
                .tabItem {
                    Label("Liste", systemImage: "list.bullet")
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
