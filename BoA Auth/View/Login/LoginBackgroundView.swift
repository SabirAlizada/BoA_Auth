//
//  LoginBackgroundView.swift
//  Boa Auth
//
//  Created by Sabir Alizada on 13.03.25.
//

import SwiftUI

struct LoginBackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.white,
                Color.backgroundBlue
            ]),
            startPoint: .top, endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}
