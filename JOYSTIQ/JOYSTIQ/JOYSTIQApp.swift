//
//  JOYSTIQApp.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 4/5/23.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
//import AmplifyPlugins

@main
struct JOYSTIQApp: App {
    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured with auth plugin")
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
