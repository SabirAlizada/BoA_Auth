//
//  DashboardView.swift
//  Boa Auth
//
//  Created by Sabir Alizada on 13.03.25.
//
// Main dashboard, including a greeting,
// a grid of bank features, and a list of recent transactions.

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
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()), GridItem(.flexible()),
                        ], spacing: 20
                    ) {
                        BankFeatureCardView(icon: "cards_icon", title: "Cards")
                        BankFeatureCardView(
                            icon: "transactions_icon", title: "Transactions")
                        BankFeatureCardView(
                            icon: "payments_icon", title: "Payments")
                        BankFeatureCardView(
                            icon: "investments_icon", title: "Investments")
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Recent Transactions")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(MockData.transactions) { transaction in
                                TransactionRow(
                                    amount: transaction.amount,
                                    category: transaction.category,
                                    date: transaction.date)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 20)
                }
                .navigationTitle("Dashboard")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        // TODO: Implement settings action
                        Button(action: {}) {
                            Image(systemName: "gearshape.fill")
                                .foregroundStyle(Color.mainBlue)
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        // TODO: Implement help action
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
}
