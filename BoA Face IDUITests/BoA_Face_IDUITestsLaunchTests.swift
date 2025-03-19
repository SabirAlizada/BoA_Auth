//
//  BoA_Face_IDUITestsLaunchTests.swift
//  BoA Face IDUITests
//
//  Created by Sabir Alizada on 13.03.25.
//

import XCTest

final class BoA_Face_IDUITestsLaunchTests: XCTestCase {
    
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    // Test case for when the device is not enrolled in biometrics.
    // In this case, tapping the login button should result in an alert.
    func testLoginShowsAlertWhenNotEnrolled() throws {
        let app = XCUIApplication()
        // Pass a launch argument to simulate the "not enrolled" state.
        app.launchArguments.append("simulateBiometricNotEnrolled")
        app.launch()
        
        // Login button text is based on biometric type.
        // If not enrolled, the alert should appear after tapping the login button.
        let loginButton = app.buttons.element(boundBy: 0)
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5), "Login button should exist")
        loginButton.tap()
        
        // Wait for the alert to appear
        let alert = app.alerts["Authentication Failed"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Alert should appear when biometric is not enrolled")
    }
    
    // Test case for a successful login where biometric authentication succeeds.
    func testSuccessfulLoginShowsDashboard() throws {
        let app = XCUIApplication()
        // Pass launch arguments to simulate an enrolled device and successful biometric authentication.
        app.launchArguments.append("simulateBiometricEnrolled")
        app.launchArguments.append("simulateBiometricSuccess")
        app.launch()
        
        // Find the Login button and tap it.
        let loginButton = app.buttons.element(boundBy: 0)
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5), "Login button should exist")
        loginButton.tap()
        
        // Verify that DashboardView is presented by checking for a known element, e.g. the Dashboard title.
        let dashboardTitle = app.staticTexts["Dashboard"]
        XCTAssertTrue(dashboardTitle.waitForExistence(timeout: 10), "Dashboard should appear after successful login")
    }
}
