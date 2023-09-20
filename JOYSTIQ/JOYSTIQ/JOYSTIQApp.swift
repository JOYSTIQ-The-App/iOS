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

class AppViewModel: ObservableObject {
    @Published var isAppInitialized: Bool = false
    @Published var authService = AuthService()

    init() {
        Task {
            await authService.fetchCurrentAuthSession()
            DispatchQueue.main.async {
                self.isAppInitialized = true
            }
        }
    }
}


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
    
    @StateObject var viewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            if !viewModel.isAppInitialized {
                LaunchScreenView()
            } else if viewModel.authService.isSignedIn {
                AppView().environmentObject(viewModel.authService)
            } else {
                LoginView().environmentObject(viewModel.authService)
            }
        }
    }
}

