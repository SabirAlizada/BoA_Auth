//
//  LoginAuthManager.swift
//  BoA Face ID
//
//  Created by Sabir Alizada on 13.03.25.
//

import LocalAuthentication

class LocalAuthManager {
    static let shared = LocalAuthManager()

    func authenticateUser(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        //TODO: Passcode fallback
        context.localizedFallbackTitle = "Use passcode instead"

        var error: NSError?

        if context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Scan your face to log in"

            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            ) { success, authentificationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        let errorMessage = self.getErrorMessage(
                            from: authentificationError)
                        completion(false, errorMessage)
                    }
                }
            }
        } else {
            // No face ID available
            DispatchQueue.main.async {
                completion(false, "Face ID is not available on this device")
            }
        }
    }

    private func getErrorMessage(from error: Error?) -> String {
        guard let error = error as? LAError else {
            return "Unknown error"
        }

        switch error.code {
        case .userCancel:
            return "Authentication cancelled"
        case .userFallback:
            return "User tapped the fallback button"
        case .biometryNotAvailable:
            return "Biometry not available"
        case .biometryNotEnrolled:
            return "Face ID is not set up. Go to Settings > Touch ID & Passcode"
        case .passcodeNotSet:
            return "Passcode is not set up. Go to Settings > Touch ID & Passcode"
        case .biometryLockout:
            return "Too many failed attempts. Face ID is locked"
        default:
            return "Unknown error"
        }
    }
}
