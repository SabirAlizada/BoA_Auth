//
//  LoginView.swift
//  Boa Auth
//
//  Created by Sabir Alizada on 13.03.25.
//
//  This view handles the login screen for the app. It shows a greeting,
//  instructs the user to authenticate using biometrics (Face ID or Touch ID),
//  and navigates to the DashboardView upon successful authentication.
//  If biometric authentication fails or the user opts for a fallback,
//  it presents a PasscodeView for further authentication.

import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @StateObject private var biometryManager = BiometryManager()
    @State private var showPasscodeView = false
    @State private var alertMessage = ""
    @State private var isAuthenticated = false
    
    var authenticationText: String {
        "Please identify your \(biometryManager.biometryType == .faceID ? "Face ID" : "Touch ID") to access our services"
    }
    var legalFootnoteText: String {
        "Bank of America, N.A Member of FDIC\n© 2025 Bank of America, N.A. All rights reserved."
    }
    var loginButtonText: String {
        biometryManager.biometryType == .faceID ? "Use Face ID" : "Use Touch ID"
    }
    var loginButtonIcon: String {
        biometryManager.biometryType == .faceID ? "faceid" : "touchid"
    }
    
    var body: some View {
        NavigationStack {
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
                            .font(.system(.largeTitle, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.black)
                        Text(authenticationText)
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                            .padding(.bottom, 40)
                        
                        Button {
                            authenticateUser()
                        } label: {
                            HStack {
                                Image(systemName: loginButtonIcon)
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                Text(loginButtonText)
                                    .font(.title2)
                                    .foregroundStyle(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.mainBlue)
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
                    
                    Text(legalFootnoteText)
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 5)
                }
                // When authentication is successful, navigate to DashboardView.
                .navigationDestination(isPresented: $isAuthenticated) {
                    DashboardView()
                }
            }
            // Present the custom PasscodeView as a full-screen cover if pressed to use passcode.
            .fullScreenCover(isPresented: $showPasscodeView) {
                PasscodeView(isAuthenticated: $isAuthenticated)
            }
            // Display an alert for authentication errors.
            .alert(isPresented: Binding<Bool>(
                get: { !alertMessage.isEmpty && !showPasscodeView },
                set: { _ in alertMessage = "" }
            )) {
                Alert(title: Text("Authentication Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // Initiates biometric authentication and handles fallback to passcode if necessary.
    private func authenticateUser() {
        AuthManager.shared.authenticateUser { success, message in
            
            if success {
                isAuthenticated = true
            } else {
                alertMessage = message ?? "Authentication failed."
                print("Authentication failed: \(alertMessage)")
                
                switch message {
                    case "User chose to enter passcode", "Biometric authentication is unavailable", "User tapped the fallback button":
                        showPasscodeView = true
                    case "Biometric authentication is not set up", "Biometry not enrolled":
                        alertMessage = "Touch ID is not set up. Please enable it in Settings."
                    default:
                        break
                }
            }
        }
    }
}
