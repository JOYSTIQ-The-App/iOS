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
            fatalError("Failed to initialize Amplify with \(error)")
        }
    }
    
    @StateObject var authService = AuthService()
    
    var body: some Scene {
        WindowGroup {
            if !authService.isAppInitialized {
                LaunchScreenView()
            } else if authService.isSignedIn, let user = authService.user {
                AppView<APIService, AuthService>(APIService: APIService())
                    .environmentObject(authService)
                    .environmentObject(user)
            } else {
                LoginView<AuthService>()
                    .environmentObject(authService)
            }
        }
    }
}


