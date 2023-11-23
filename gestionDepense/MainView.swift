//
//  MainView.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 21/11/2023.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    @State private var isPresented: Bool = false
    @StateObject var userSettings: UserSettings
    @StateObject var depensesManager: DepensesManager

    init() {
        let userSettings = UserSettings()
        self._userSettings = StateObject(wrappedValue: userSettings)
        self._depensesManager = StateObject(wrappedValue: DepensesManager(userSettings: userSettings))
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {

            DepensesListView(depensesManager: depensesManager)
                .tabItem {
                    Label("Liste", systemImage: "list.bullet")
                }
                .tag(0)
            
            ChartView(depensesManager: depensesManager, userSettings: userSettings)
                .tabItem {
                    Label("Graphique", systemImage: "chart.pie")
                }
                .tag(1)
            
            ProfileView(userSettings: userSettings, depensesManager: depensesManager)
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle")
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
