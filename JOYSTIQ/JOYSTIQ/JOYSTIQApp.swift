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
    @Published var user = User()
    
    init() {
        Task {
            await initializeApp()
        }
    }

    func initializeApp() async {
        print("initializing app")
        print("fetching current auth session")
        await authService.fetchCurrentAuthSession()
        
        // Fetch email
        if let email = try? await authService.fetchUserEmail() {
            user.email = email
            print(email)
        } else {
            print("Error retrieving user email.")
        }

        // Fetch username
        let userIdentifier: UserIdentifier = .email("ssottosanti@joystiq.gg")
        APIService().getUsername(for: userIdentifier) { result in
            switch result {
            case .success(let username):
                print(username)
                DispatchQueue.main.async {
                    self.user.username = username
                }
            case .failure(let error):
                print("Error getting username: \(error.localizedDescription)")
            }
        }

        DispatchQueue.main.async {
            print("App is initialized")
            self.isAppInitialized = true
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
                AppView<AuthService>()
                    .environmentObject(viewModel.authService)
                    .environmentObject(viewModel.user)
            } else {
                LoginView<AuthService>()
                    .environmentObject(viewModel.authService)
            }
        }
    }
}

