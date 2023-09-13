//
//  JOYSTIQApp.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 4/5/23.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin

@main
struct JOYSTIQApp: App {
    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.configure()
            print("Amplify configured with Auth and Storage plugins")
        } catch {
            // This is a fatal error. Crash the app so it's obvious something went wrong.
            // In production, you should display an appropriate error message to the user.
            fatalError("Failed to initialize Amplify with \(error)")
        }
    }
    
    @StateObject var authService = AuthService()
    
    var body: some Scene {
        WindowGroup {
            if authService.isSignedIn {
                AppView().environmentObject(authService)
            } else {
                LoginView().environmentObject(authService)
            }
        }
    }
}
