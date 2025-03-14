//
//  DashboardView.swift
//  BoA Face ID
//
//  Created by Sabir Alizada on 13.03.25.
//

import SwiftUI

struct DashboardView: View {
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Welcome back!")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .foregroundStyle(.gray)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],spacing: 20) {
                        BankFeatureCardView(icon: "cards_icon", title: "Cards")
                        BankFeatureCardView(icon: "transactions_icon", title: "Transactions")
                        BankFeatureCardView(icon: "payments_icon", title: "Payments")
                        BankFeatureCardView(icon: "investments_icon", title: "Investements")
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Recent Transactions")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        List(MockData.transactions) { transaction in
                            TransactionRow(amount: transaction.amount, category: transaction.category, date: transaction.date)
                        }
                        .frame(height: 350)
                    }
                }
                .padding(.top, 20)
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(Color.mainBlue)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "questionmark.bubble")
                            .foregroundStyle(Color.mainBlue)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    DashboardView()
}
