//
//  LoginAuthManager.swift
//  BoA Face ID
//
//  Created by Sabir Alizada on 13.03.25.
//

import LocalAuthentication

class AuthManager {
    static let shared = AuthManager()
    
    func authenticateUser(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        context.localizedFallbackTitle = "Use passcode instead"
        var error: NSError?
        
        // Check if device supports biometrics
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(false, "This app requires biometric authentication for security. Please enable it in Settings.")
            return
        }
        
        let biometryType = context.biometryType
        
        // Validate if biometrics are enrolled
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
    
    private func isBiometryNotEnrolled(_ error: NSError?) -> Bool {
        return error?.code == LAError.biometryNotEnrolled.rawValue
    }
    
    private func getErrorMessage(from error: Error?) -> String? {
        guard let error = error as? LAError else {
            return "Biometry is not available"
        }
        
        switch error.code {
            case .userCancel:
                return "Authentication cancelled"
            case .userFallback:
                return "User tapped the fallback button"
            case .biometryNotAvailable:
                return "Biometry authentication is not available"
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

// Manages the device's biometric capability
class BiometryManager: ObservableObject {
    @Published var biometryType: LABiometryType = .none
    
    init() {
        self.updateBioemetryType()
    }
    
    private func updateBioemetryType() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            DispatchQueue.main.async {
                self.biometryType = context.biometryType
            }
        } else if error?.code == LAError.biometryNotEnrolled.rawValue {
            DispatchQueue.main.async {
                self.biometryType = context.biometryType
            }
        }
    }
}
