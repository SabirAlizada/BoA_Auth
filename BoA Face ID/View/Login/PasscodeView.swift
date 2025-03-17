//
//  PasscodeView.swift
//  BoA Face ID
//
//  Created by Sabir Alizada on 14.03.25.
//

import SwiftUI

struct PasscodeView: View {
    @Binding var isAuthenticated: Bool
    @State private var enteredPasscode: String = ""
    @State private var showError: Bool = false
    @FocusState private var isKeyboardFocused: Bool
    
    private let correctPasscode: String = "1234"
    
    var body: some View {
        NavigationStack {
            ZStack {
                LoginBackgroundView()
                    .blur(radius: 1, opaque: true)
                VStack {
                    Text("Enter Passcode")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.bottom, 20)
                    SecureField("••••", text: $enteredPasscode)
                        .font(.largeTitle)
                        .padding()
                        .multilineTextAlignment(.center)
                        .cornerRadius(10)
                        .keyboardType(.numberPad)
                        .frame(width: 200)
                        .foregroundStyle(.white)
                        .focused($isKeyboardFocused)
                        .onAppear {
                            isKeyboardFocused = true
                        }
                        .onChange(of: enteredPasscode) { _, newValue in
                            if !newValue.isEmpty {
                                showError = false
                            }
                            if newValue.count > 4 {
                                enteredPasscode = String(newValue.prefix(4))
                            }
                        }
                    if showError {
                        Text("Incorrect passcode. Try again.")
                            .font(.subheadline)
                            .foregroundStyle(.red)
                            .padding(.top, 3)
                    }
                    Button("Login") {
                        if enteredPasscode == correctPasscode {
                            isAuthenticated = true
                        } else {
                            showError = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                enteredPasscode = ""
                            }
                        }
                    }
                    .padding()
                    .frame(width: 200)
                    .background(enteredPasscode.count == 4 ? Color.backgroundBlue : Color.gray)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .padding(.top, 10)
                    .disabled(enteredPasscode.count < 4)
                }
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $isAuthenticated) {
                DashboardView()
            }
        }
    }
}
