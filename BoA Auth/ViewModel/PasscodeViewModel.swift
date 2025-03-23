//
//  PasscodeViewModel.swift
//  BoA Auth
//
//  Created by Sabir Alizada on 19.03.25.
//

import SwiftUI

class PasscodeViewModel: ObservableObject {
    @Published var enteredPasscode: String = ""
    @Published var showError: Bool = false
    @Published var failedAttempts: Int = UserDefaults.standard.integer(forKey: "failedAttempts")
    @Published var isLocked: Bool = false
    @Published var remainingTime: Int = 0
    @Published var alertMessage: String = ""
    @Published var biometryManager = BiometryManager()
    
    var timer: Timer?
    var biometricButtonIcon: String {
        biometryManager.biometryType == .faceID ? "faceid" : "touchid"
    }
    
    // MARK: - Correct Passcode
    // Hardcoded correct passcode for authentication (for demo purposes)
    private let correctPasscode: String = "1234"
    
    func loadBiometry() {
        DispatchQueue.main.async {
            self.biometryManager = BiometryManager()
        }
    }
    
    // Attempts to log in using the entered passcode
    func login(completion: @escaping (Bool) -> Void) {
        if enteredPasscode == correctPasscode {
            resetLock()
            completion(true)
        } else {
            failedAttempts += 1
            UserDefaults.standard.set(failedAttempts, forKey: "failedAttempts")
            
            if failedAttempts >= 3 {
                isLocked = true
                let lockTime = Date()
                UserDefaults.standard.set(lockTime, forKey: "lockStartTime")
                remainingTime = 180
                startLockTimer()
            } else {
                showError = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.enteredPasscode = ""
                }
            }
            completion(false)
        }
    }
    
    // Checks if the lockout period is active based on stored lock time
    // If the lockout is still in effect, updates the remaining time and starts the timer; otherwise, resets the lock state
    func checkLockStatus() {
        if let lockTime = UserDefaults.standard.object(forKey: "lockStartTime") as? Date {
            let elapsedTime = Int(Date().timeIntervalSince(lockTime))
            if elapsedTime < 180 {
                isLocked = true
                remainingTime = 180 - elapsedTime
                startLockTimer()
            } else {
                resetLock()
            }
        }
    }
    
    // Starts a timer that decrements the remaining lockout time every second
    // When the remaining time reaches zero, the lock state is reset
    func startLockTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.resetLock()
            }
        }
    }
    
    // Resets the lockout state by clearing failed attempts and removing stored lock data
    func resetLock() {
        isLocked = false
        failedAttempts = 0
        UserDefaults.standard.removeObject(forKey: "lockStartTime")
        UserDefaults.standard.removeObject(forKey: "failedAttempts")
        timer?.invalidate()
        timer = nil
    }
    
    // Performs biometric authentication using the AuthManager
    func authenticateBiometrics(completion: @escaping (Bool) -> Void) {
        AuthManager.shared.authenticateUser { success, message in
            if success {
                completion(true)
            } else {
                self.alertMessage = message ?? "Authentication failed."
                self.enteredPasscode = ""
                self.showError = false
                completion(false)
            }
        }
    }
}
