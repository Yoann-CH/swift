//
//  MainView.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 21/11/2023.
//

import SwiftUI

struct MainView: View {
    @StateObject private var depensesManager = DepensesManager()
    @State private var selectedTab = 0
    @State private var isPresented: Bool = false

    var body: some View {
        TabView(selection: $selectedTab) {

            DepensesListView(depensesManager: depensesManager)
                .tabItem {
                    Label("Liste", systemImage: "list.bullet")
                }
                .tag(0)
            
            EditDepenseView(depensesManager: depensesManager, isPresented: $isPresented)
                .tabItem {
                    Label("Ajouter", systemImage: "plus.circle")
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
