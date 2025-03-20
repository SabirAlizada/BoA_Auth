//
//  BoA_AuthTests.swift
//  Boa AuthTests
//
//  Created by Sabir Alizada on 13.03.25.
//

import XCTest
import LocalAuthentication
@testable import BoA_Auth

final class AuthManagerTests: XCTestCase {
    
    func testGetErrorMessageForUserCancel() {
        let error = LAError(.userCancel)
        let message = AuthManager.shared.getErrorMessage(from: error)
        XCTAssertEqual(message, "Authentication cancelled")
    }
    
    func testGetErrorMessageForUserFallback() {
        let error = LAError(.userFallback)
        let message = AuthManager.shared.getErrorMessage(from: error)
        XCTAssertEqual(message, "User tapped the fallback button")
    }
    
    func testGetErrorMessageForBiometryNotAvailable() {
        let error = LAError(.biometryNotAvailable)
        let message = AuthManager.shared.getErrorMessage(from: error)
        XCTAssertEqual(message, "Biometric authentication is not available")
    }
    
    func testIsBiometryNotEnrolledReturnsTrue() {
        let error = NSError(domain: LAError.errorDomain, code: LAError.biometryNotEnrolled.rawValue, userInfo: nil)
        let result = AuthManager.shared.isBiometryNotEnrolled(error)
        XCTAssertTrue(result)
    }
    
    func testIsBiometryNotEnrolledReturnsFalse() {
        let error = NSError(domain: LAError.errorDomain, code: LAError.userCancel.rawValue, userInfo: nil)
        let result = AuthManager.shared.isBiometryNotEnrolled(error)
        XCTAssertFalse(result)
    }
}
