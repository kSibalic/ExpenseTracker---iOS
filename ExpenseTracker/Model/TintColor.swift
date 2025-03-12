//
//  TintColor.swift
//  ExpenseTracker
//
//  Created by Karlo Šibalić on 10.03.2025..
//

import SwiftUI

struct TintColor: Identifiable {
    let id: UUID = .init()
    var color: String
    var value: Color
}

var tints: [TintColor] = [
    .init(color: "Green", value: .green),
    .init(color: "Blue", value: .blue),
    .init(color: "Purple", value: .purple),
    .init(color: "Yellow", value: .yellow),
    .init(color: "Orange", value: .orange),
    .init(color: "Red", value: .red),
    .init(color: "Pink", value: .pink),
    .init(color: "Gray", value: .gray),
    .init(color: "Brown", value: .brown),
    .init(color: "Black", value: .black),
]
