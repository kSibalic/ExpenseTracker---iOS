//
//  Tab.swift
//  ExpenseTracker
//
//  Created by Karlo Šibalić on 10.03.2025..
//

import SwiftUI

enum Tab: String {
    case recents = "Recents"
    case search = "Search"
    case charts = "Charts"
    case settings = "Settings"
    
    @ViewBuilder
    var tabContent: some View {
        switch self {
        case .recents:
            Image(systemName: "calendar")
            Text(self.rawValue)
        case .search:
            Image(systemName: "magnifyingglass")
            Text(self.rawValue)
        case .charts:
            Image(systemName: "chart.pie.fill")
            Text(self.rawValue)
        case .settings:
            Image(systemName: "gearshape")
            Text(self.rawValue)
        }
    }
}
