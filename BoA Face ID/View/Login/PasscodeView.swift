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
    @StateObject private var biometryManager = BiometryManager()
    @State private var alertMessage = ""
    
    var bimetricButtonIcon: String {
        biometryManager.biometryType == .faceID ? "faceid" : "touchid"
    }
    
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
                            DispatchQueue.main.async{
                                isKeyboardFocused = true
                            }
                        }
                        .onChange(of: enteredPasscode) { _, newValue in
                            // Remove error message as user starts typing
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
                    HStack(spacing: 40) {
                        Spacer()
                        
                        Button {
                            if enteredPasscode == correctPasscode {
                                // Navigate to DashboardView when passcode is correct
                                isAuthenticated = true
                            } else {
                                showError = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    enteredPasscode = ""
                                }
                            }
                        } label: {
                            Text("Login")
                                .frame(width: 180, height: 50)
                                .background(enteredPasscode.count == 4 ? Color.backgroundBlue : Color.gray)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                        }
                        .contentShape(Rectangle())
                        .padding(.top, 10)
                        .padding(.leading, 80)
                        .disabled(enteredPasscode.count < 4)
                        
                        // Biometric authentication button (only shown if device supports biometrics)
                        if biometryManager.biometryType != .none {
                            Button {
                                authenticateBiometrics()
                            } label: {
                                Image(systemName: bimetricButtonIcon)
                                    .font(.title)
                                    .foregroundStyle(.white)
                                    .padding(.top, 10)
                            }
                        }
                        
                        Spacer()
                    }
                    Button("Forgot passcode?") {}
                        .font(.subheadline)
                        .foregroundStyle(.thinMaterial)
                        .padding(.top, 15)
                }
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $isAuthenticated) {
                DashboardView()
            }
        }
    }
    
    // Attempts biometric authentication and navigates to the dashboard if successful.
    private func authenticateBiometrics() {
        AuthManager.shared.authenticateUser { success, message in
            if success {
                self.isAuthenticated = true
            } else {
                alertMessage = message ?? "Authentication failed."
                enteredPasscode = ""
                showError = false
            }
        }
    }
}
