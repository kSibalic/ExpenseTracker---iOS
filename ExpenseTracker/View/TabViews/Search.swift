//
//  Search.swift
//  ExpenseTracker
//
//  Created by Karlo Šibalić on 10.03.2025..
//
import SwiftUI
import Combine

struct Search: View {
    @State private var searchText: String = ""
    @State private var filterText: String = ""
    @State private var selectedCategory: Category? = nil
    
    let searchPublisher = PassthroughSubject<String, Never>()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    FilterCapsule(title: "Both", isSelected: selectedCategory == nil) {
                        selectedCategory = nil
                    }
                    
                    ForEach(Category.allCases, id: \.rawValue) { category in
                        FilterCapsule(title: category.rawValue, isSelected: selectedCategory == category) {
                            selectedCategory = category
                        }
                    }
                    Spacer()
                }
                
                ScrollView(.vertical) {
                    LazyVStack(spacing: 12) {
                        FilterTransactionView(category: selectedCategory, searchText: filterText) { transactions in
                            ForEach(transactions) { transaction in
                                NavigationLink {
                                    TransactionView(editTransaction: transaction)
                                } label: {
                                    TransactionCardView(transaction: transaction, showsCategory: true)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(15)
                }
                .overlay(content: {
                    ContentUnavailableView("Search your transactions", systemImage: "magnifyingglass")
                        .opacity(filterText.isEmpty ? 1 : 0)
                })
            }
            .onChange(of: searchText, { oldValue, newValue in
                if newValue.isEmpty {
                    filterText = ""
                }
                searchPublisher.send(newValue)
            })
            .onReceive(searchPublisher.debounce(for: .seconds(0.3), scheduler: DispatchQueue.main), perform: { text in
                filterText = text
            })
            .searchable(text: $searchText)
            .navigationTitle("Search")
            .background(.gray.opacity(0.15))
        }
    }
}

struct FilterCapsule: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.callout)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? appTint.opacity(0.9) : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    Search()
}
