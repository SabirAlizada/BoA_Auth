//
//  PasscodeView.swift
//  Boa Auth
//
//  Created by Sabir Alizada on 14.03.25.
// This view represents the passcode entry interface for authentication. It handles secure passcode input, biometric authentication button,
// and lockout mechanism after multiple failed attempts. The view uses a PasscodeViewModel to manage authentication logic.

import SwiftUI

struct PasscodeView: View {
    @Binding var isAuthenticated: Bool
    @StateObject private var viewModel = PasscodeViewModel()
    @FocusState private var isKeyboardFocused: Bool
    
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
                    
                    SecureField("••••", text: $viewModel.enteredPasscode)
                        .font(.largeTitle)
                        .padding()
                        .multilineTextAlignment(.center)
                        .cornerRadius(10)
                        .keyboardType(.numberPad)
                        .frame(width: 200)
                        .foregroundStyle(.white)
                        .focused($isKeyboardFocused)
                        .onAppear {
                            DispatchQueue.main.async {
                                isKeyboardFocused = true
                            }
                            viewModel.loadBiometry()
                            viewModel.checkLockStatus()
                        }
                        .onChange(of: viewModel.enteredPasscode) {
                            _, newValue in
                            
                            // Removes error message as user starts typing
                            if !newValue.isEmpty {
                                viewModel.showError = false
                            }
                            
                            // Limits passcode length to 4 digits
                            if newValue.count > 4 {
                                viewModel.enteredPasscode = String(newValue.prefix(4))
                            }
                        }
                    
                    if viewModel.showError {
                        Text("Incorrect passcode. Try again.")
                            .font(.subheadline)
                            .foregroundStyle(.red)
                            .padding(.top, 3)
                    }
                    
                    ZStack {
                        Button {
                            viewModel.login { success in
                                if success {
                                    isAuthenticated = true
                                }
                            }
                        } label: {
                            Text(
                                viewModel.isLocked
                                ? "Try again in \(viewModel.remainingTime)s"
                                : "Login"
                            )
                            .frame(width: 160, height: 50)
                            .background(
                                viewModel.enteredPasscode.count == 4
                                && !viewModel.isLocked
                                ? Color.backgroundBlue : Color.gray
                            )
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                        }
                        .contentShape(Rectangle())
                        .padding(.top, 10)
                        .disabled(
                            viewModel.enteredPasscode.count < 4 || viewModel.isLocked
                        )
                        
                        // Biometric authentication button (only shown if device supports biometrics)
                        if viewModel.biometryManager.biometryType != .none {
                            Button {
                                viewModel.authenticateBiometrics { success in
                                    if success {
                                        isAuthenticated = true
                                    }
                                }
                            } label: {
                                Image(systemName: viewModel.biometricButtonIcon)
                                    .font(.title)
                                    .foregroundStyle(.white)
                                    .padding(.top, 10)
                            }
                            .offset(x: 80 + 65, y: 0)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Placeholder for future 'Forgot passcode' functionality
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
        .onDisappear {
            // Invalidate the timer when the view disappears to clean up resources
            viewModel.timer?.invalidate()
        }
    }
}
