//
//  MockData.swift
//  BoA Face ID
//
//  Created by Sabir Alizada on 13.03.25.
//

import Foundation

struct MockTransaction: Identifiable {
    let id = UUID()
    let amount: String
    let category: String
    let date: String
}

struct MockData {
    static let transactions: [MockTransaction] = [
        MockTransaction(amount: "-$120.50", category: "Groceries", date: "Mar 12, 2025"),
        MockTransaction(amount: "-$75.00", category: "Uber Ride", date: "Mar 11, 2025"),
        MockTransaction(amount: "+$1,500.00", category: "Salary", date: "Mar 10, 2025"),
        MockTransaction(amount: "-$13.00", category: "Coffee Shop", date: "Mar 09, 2025"),
        MockTransaction(amount: "-$20.00", category: "Gasoline", date: "Mar 08, 2025"),
        MockTransaction(amount: "-$100.00", category: "Restaurant", date: "Mar 07, 2025")
    ]
}
