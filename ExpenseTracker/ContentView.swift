//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Karlo Šibalić on 10.03.2025..
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground: Bool = false
    
    @State private var activeTab: Tab = .recents
    var body: some View {
        LockView(lockType: .both, lockPin: "123456", isEnabled: isAppLockEnabled, lockWhenAppGoesBackground: lockWhenAppGoesBackground) {
            TabView(selection: $activeTab) {
                Recents()
                    .tag(Tab.recents)
                    .tabItem{Tab.recents.tabContent}
                
                Search()
                    .tag(Tab.search)
                    .tabItem{Tab.search.tabContent}
                
                Charts()
                    .tag(Tab.charts)
                    .tabItem{Tab.charts.tabContent}
                
                Settings()
                    .tag(Tab.settings)
                    .tabItem{Tab.settings.tabContent}
            }
            .tint(appTint)
            .sheet(isPresented: $isFirstTime, content: {
                IntroScreen()
                    .interactiveDismissDisabled()
            })
        }
    }
}

#Preview {
    ContentView()
}
