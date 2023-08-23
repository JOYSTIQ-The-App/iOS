//
//  AuthService.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 6/26/23.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

class AuthService: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var isSignedUp: Bool = false
    @Published var isConfirmed: Bool = false
    @Published var signUpRequested: Bool = false

    init() {
        Task {
            do {
                let session = try await Amplify.Auth.fetchAuthSession()
                DispatchQueue.main.async {
                    self.isSignedIn = session.isSignedIn
                }
                print("Is user signed in - \(session.isSignedIn)")
            } catch let error as AuthError {
                print("Fetch session failed with error \(error)")
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }

    func fetchCurrentAuthSession() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            print("Is user signed in - \(session.isSignedIn)")
            DispatchQueue.main.async {
                self.isSignedIn = session.isSignedIn
            }
        } catch let error as AuthError {
            print("Fetch session failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    func signIn(username: String, password: String) async {
        do {
            let signInResult = try await Amplify.Auth.signIn(
                username: username,
                password: password
                )

            DispatchQueue.main.async {
                self.isSignedIn = signInResult.isSignedIn
            }

            if signInResult.isSignedIn {
                print("Sign in succeeded")
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func signUp(username: String, email: String, password: String) async -> Bool {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        do {
            let signUpResult = try await Amplify.Auth.signUp(
                username: username,
                password: password,
                options: options
            )
            if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
                return true
            } else {
                print("SignUp Complete")
            }
            return signUpResult.isSignUpComplete
        } catch let error as AuthError {
            print("An error occurred while registering a user \(error)")
            return false
        } catch {
            print("Unexpected error: \(error)")
            return false
        }
    }
    
    func confirmSignUp(for username: String, with confirmationCode: String) async -> Bool {
        do {
            let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
                for: username,
                confirmationCode: confirmationCode
            )
            print("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
            return confirmSignUpResult.isSignUpComplete
        } catch let error as AuthError {
            print("An error occurred while confirming sign up \(error)")
            return false
        } catch {
            print("Unexpected error: \(error)")
            return false
        }
    }

    func signOutLocally() async {
        let result = await Amplify.Auth.signOut()
        guard let signOutResult = result as? AWSCognitoSignOutResult
        else {
            print("Signout failed")
            return
        }


        print("Local signout successful: \(signOutResult.signedOutLocally)")
//        if signOutResult.signedOutLocally {
//            DispatchQueue.main.async {
//                self.isSignedIn = false
//            }
//        }
        switch signOutResult {
        case .complete:
            // Sign Out completed fully and without errors.
            print("Signed out successfully")

        case let .partial(revokeTokenError, globalSignOutError, hostedUIError):
            // Sign Out completed with some errors. User is signed out of the device.

            if let hostedUIError = hostedUIError {
                print("HostedUI error  \(String(describing: hostedUIError))")
            }

            if let globalSignOutError = globalSignOutError {
                // Optional: Use escape hatch to retry revocation of globalSignOutError.accessToken.
                print("GlobalSignOut error  \(String(describing: globalSignOutError))")
            }

            if let revokeTokenError = revokeTokenError {
                // Optional: Use escape hatch to retry revocation of revokeTokenError.accessToken.
                print("Revoke token error  \(String(describing: revokeTokenError))")
            }

        case .failed(let error):
            // Sign Out failed with an exception, leaving the user signed in.
            print("SignOut failed with \(error)")
        }
    }
}
