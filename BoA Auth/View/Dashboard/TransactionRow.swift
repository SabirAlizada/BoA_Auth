//
//  TransactionRow.swift
//  Boa Auth
//
//  Created by Sabir Alizada on 13.03.25.
//

import SwiftUI

struct TransactionRow: View {
    let amount: String
    let category: String
    let date: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(category)
                    .font(.headline)
                Text(date)
                    .font(.subheadline)
                    .font(.caption)
            }
            Spacer()
            
            Text(amount)
                .fontWeight(.bold)
                .foregroundColor(amount.hasPrefix("+") ? Color.transactionGreen : Color.transactionRed)
        }
        .padding(.vertical, 5)
    }
}
