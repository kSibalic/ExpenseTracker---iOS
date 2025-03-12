//
//  IntroScreen.swift
//  ExpenseTracker
//
//  Created by Karlo Šibalić on 10.03.2025..
//

import SwiftUI

struct IntroScreen: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    var body: some View {
        VStack(spacing: 15) {
            Text("What's new in the new\nExpenseTracker 2025?")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 65)
                .padding(.bottom, 35)
            
            VStack(alignment: .leading, spacing: 25, content: {
                PointView(symbol: "dollarsign", title: "Transactions", subTitle: "Keep track of your incomes and expanses")
                
                PointView(symbol: "chart.pie.fill", title: "New Charts", subTitle: "All new eye-catching graphic representations")
                
                PointView(symbol: "magnifyingglass", title: "Advanced Searching", subTitle: "Advanced transtaction search and filtering")
                
                PointView(symbol: "sparkles", title: "AI Assistant", subTitle: "Personal AI assistant to make your finance impeccable")
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            .fontWeight(.light)
            
            Spacer(minLength: 10)
            
            Button(action: {
                isFirstTime = false
            }, label: {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(appTint, in: .rect(cornerRadius: 12))
                    .contentShape(.rect)
            })
            .padding(.horizontal, 40)
        }
        .padding(15)
    }
    
    @ViewBuilder
    func PointView(symbol: String, title: String, subTitle: String) -> some View {
        HStack(spacing: 20) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(appTint)
                .frame(width: 45)
            
            VStack(alignment: .leading, spacing: 6, content: {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subTitle)
                    .foregroundStyle(.gray)
            })
        }
    }
}

#Preview {
    IntroScreen()
}
