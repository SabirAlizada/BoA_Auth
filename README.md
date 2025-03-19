# Overview

This project is a minimal SwiftUI application that demonstrates biometric authentication using Face ID and Touch ID, with a fallback to a custom passcode entry screen.  
The app is designed to showcase best practices in iOS development and code architecture.

## Features

- **Biometric Authentication**  
  Uses the device’s Face ID or Touch ID to authenticate users securely.  

- **Custom Passcode Fallback**  
  If biometric authentication fails or if the user is not enrolled, a custom passcode screen (4-digit code) is provided.  

- **Dynamic UI Updates**  
  The app updates its user interface based on biometric capabilities and user actions.  

- **Clean and Modular Code**  
  The project is structured to separate concerns (e.g., authentication logic, UI views, and biometric management) following best practices.  

- **Error Handling**  
  User-friendly error messages inform the user if authentication fails or if biometrics are not configured.  

## Technology Stack

- **SwiftUI**: Used for building the app’s user interface.  
- **LocalAuthentication Framework**: Handles biometric authentication.  
- **Combine/ObservableObject**: Manages state updates for biometric capabilities.  

## Project Structure

- **`AuthManager.swift`**  
  Contains the logic for biometric authentication and error handling.  

- **`BiometryManager.swift`**  
  Observes and updates the device’s biometric capabilities.  

- **`LoginView.swift`**  
  The initial login screen that prompts the user for biometric authentication.  

- **`PasscodeView.swift`**  
  A custom passcode entry screen that is displayed if biometric authentication fails.  

- **`DashboardView.swift`**  
  A sample dashboard screen to indicate a successful login.  

## How It Works

1. **Biometric Check**  
   The app first checks if the device supports biometric authentication and whether the user is enrolled. If not, it notifies the user to enable biometrics in Settings.  

2. **Authentication Process**  
   - If biometrics are available and enrolled, the app attempts authentication using Face ID or Touch ID.  
   - If the user opts for passcode fallback (or if biometrics fail), the app displays a custom 4-digit passcode entry screen.  

3. **Navigation**  
   Upon successful authentication (either biometric or passcode), the app navigates to the `DashboardView`.  

## Installation

1. Clone the repository.  
2. Open the project in Xcode.  
3. Build and run on an iOS simulator or device (preferably one with biometric capabilities).  

## Usage

- Launch the app and follow the on-screen instructions to authenticate using Face ID, Touch ID, or your passcode.  
- If biometric authentication fails, the custom passcode screen will appear.  
- Successful authentication navigates you to a sample dashboard screen.  

## Best Practices Implemented

- **Separation of Concerns**  
  Each functionality (authentication, biometric management, UI) is separated into its own file.  

- **Modern SwiftUI Navigation**  
  Utilizes `NavigationStack` and `navigationDestination(isPresented:)` for smooth transitions.  

- **Error Handling and UI Feedback**  
  Provides clear error messages and gracefully handles fallback scenarios.  

- **State Management**  
  Uses SwiftUI’s state and Combine patterns for reactive UI updates.  
