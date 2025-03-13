//
//  LoginView.swift
//  BoA Face ID
//
//  Created by Sabir Alizada on 13.03.25.
//

import SwiftUI

struct LoginView: View {
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            LoginBackgroundView()
            VStack {
                Image("boa_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 80)
                    .padding(.top, 40)
                Spacer()
                VStack(spacing: 16) {
                    Text("Welcome back!")
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .multilineTextAlignment(.center)
                    Text("Please identify your Face ID to access ou services")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                        .padding(.bottom, 40)
                    
                    Button {
                        authetificateUser()
                    } label: {
                        HStack {
                            Image(systemName: "faceid")
                                .font(.title2)
                                .foregroundStyle(.white)
                            Text("Use Face ID")
                                .font(.title2)
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 24)
                }
                .padding()
                .background(.white)
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(24)
                .offset(y: -90)
                
                Spacer()
                
                Text("Bank of America, N.A Member of FDIC\n© 2025 Bank of America, N.A. All rights reserved.")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Authentication Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func authetificateUser() {
        LocalAuthManager.shared.authenticateUser { success, message in
            if success {
                // TODO: Navigate to the dashboard
                print("Authentification successfull. Navigate to the next screen.")
            } else {
                alertMessage = message ?? "Authentification failed."
                showAlert = true
            }
        }
    }
}

#Preview {
    LoginView()
}

