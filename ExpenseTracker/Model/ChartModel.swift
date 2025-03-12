//
//  ChartModel.swift
//  ExpenseTracker
//
//  Created by Karlo Šibalić on 11.03.2025..
//

import SwiftUI

struct ChartGroup: Identifiable {
    let id: UUID = .init()
    var date: Date
    var categories: [ChartCategory]
    var totalIncome: Double
    var totalExpenses: Double
}
    
struct ChartCategory: Identifiable {
    let id: UUID = .init()
    var totalValue: Double
    var category: Category
}
