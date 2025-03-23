//
//  LoginAuthManager.swift
//  Boa Auth
//
//  Created by Sabir Alizada on 13.03.25.
//
//  This file manages user authentication using biometrics (Face ID / Touch ID).

import LocalAuthentication

class AuthManager {
    static let shared = AuthManager()
    
    // Manages authentication using biometric methods.
    func authenticateUser(completion: @escaping (Bool, String?) -> Void) {
        
        // If simulation arguments are provided, uses them to simulate authentication behavior for UI testing.
        if simulateBiometricIfNeeded(completion: completion) { return }
        
        let context = LAContext()
        context.localizedFallbackTitle = "Use passcode instead"
        var error: NSError?
        
        // Checks if device supports biometrics
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(false, "This app requires biometric authentication for security. Please enable it in Settings.")
            return
        }
        
        let biometryType = context.biometryType
        
        // Validates if biometrics are enrolled on the device
        guard !isBiometryNotEnrolled(error) else {
            completion(false, "Biometric autentication is not set up. Please enable it in Settings.")
            return
        }
        
        let reason = biometryType == .faceID ? "Scan your face to log in" : "Use Touch ID to log in"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
            DispatchQueue.main.async {
                completion(success, self.getErrorMessage(from: authenticationError))
            }
        }
    }
    
    func isBiometryNotEnrolled(_ error: NSError?) -> Bool {
        return error?.code == LAError.biometryNotEnrolled.rawValue
    }
    
    func getErrorMessage(from error: Error?) -> String? {
        guard let error = error as? LAError else {
            return "Biometry is not available"
        }
        
        // Converts an LAError to a user-friendly error message
        switch error.code {
            case .userCancel:
                return "Authentication cancelled"
            case .userFallback:
                return "User tapped the fallback button"
            case .biometryNotAvailable:
                return "Biometric authentication is not available"
            case .biometryNotEnrolled:
                return "Biometric authentication is not set up. Go to Settings > Touch or Face ID & Passcode"
            case .passcodeNotSet:
                return "Passcode is not set up. Go to Settings > Touch or Face ID & Passcode"
            case .biometryLockout:
                return "Too many failed attempts. Biometric authentication is locked"
            default:
                return "Unknown authentication error"
        }
    }
}

// Observes and reports the device's biometric capability.
class BiometryManager: ObservableObject {
    @Published var biometryType: LABiometryType = .none
    init() {
        updateBiometryType()
    }
    
    // Checks if the device supports biometric authentication.
    private func updateBiometryType() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            self.biometryType = context.biometryType
        } else {
            self.biometryType = .none
        }
    }
}

extension AuthManager {
    // Helper function that checks for the simulation launch arguments
    func simulateBiometricIfNeeded(completion: @escaping (Bool, String?) -> Void) -> Bool {
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains("simulateBiometricNotEnrolled") {
            completion(false, "Biometric authentication is not set up. Please enable it in Settings.")
            return true
        }
        if arguments.contains("simulateBiometricSuccess") {
            completion(true, nil)
            return true
        }
        return false
    }
}
