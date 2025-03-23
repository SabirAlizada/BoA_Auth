//
//  BankFeatureCardView.swift
//  Boa Auth
//
//  Created by Sabir Alizada on 13.03.25.
//  View used for presenting a grid with of features

import SwiftUI

struct BankFeatureCardView: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack {
            Button( action: {
            }) {
                VStack(spacing: 8) {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                        .font(.largeTitle)
                        .padding()
                }
                .frame(width: 130, height: 100)
                .background(.white)
                .cornerRadius(15)
                .shadow(radius: 3)
            }
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding()
        }
    }
}

