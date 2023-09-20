//
//  AuthService.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 6/26/23.
//

import Foundation
import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

protocol AuthServiceProtocol: ObservableObject {
    var isSignedIn: Bool { get set }
    var isSignedUp: Bool { get set }
    var isConfirmed: Bool { get set }
    var signUpRequested: Bool { get set }
    
    func fetchCurrentAuthSession() async
    func fetchUserEmail() async throws -> String?
    func signIn(username: String, password: String, completion: @escaping (Bool, Bool) -> Void) async
    func signUp(username: String, email: String, password: String) async -> Bool
    func confirmSignUp(for username: String, with confirmationCode: String) async -> Bool
    func resendConfirmationCode(for username: String) async -> Bool
    func resetPassword(username: String, completion: @escaping (Bool) -> Void) async
    func confirmResetPassword(username: String, newPassword: String, confirmationCode: String, completion: @escaping (Bool) -> Void) async
    func signOutLocally() async
}


class AuthService: AuthServiceProtocol {
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
    
    func fetchUserEmail() async throws -> String? {
        do {
            let attributes = try await Amplify.Auth.fetchUserAttributes()
            
            for attribute in attributes {
                if attribute.key == .email {
                    print("Users email:", attribute.value)
                    return attribute.value
                }
            }
            
            throw NSError(domain: "JOYSTIQ", code: 400, userInfo: [NSLocalizedDescriptionKey: "Email not found in user attributes"])
        } catch let error as AuthError {
            print("Fetching user attributes failed with error \(error)")
            throw error
        } catch {
            print("Unexpected error: \(error)")
            throw error
        }
    }



    func signIn(username: String, password: String, completion: @escaping (Bool, Bool) -> Void) async {
        do {
            let signInResult = try await Amplify.Auth.signIn(username: username, password: password)
            let nextStep = signInResult.nextStep

            if case .confirmSignUp(let info) = nextStep {
                print("Confirm signup additional info \(String(describing: info))")
                if signInResult.isSignedIn {
                    print("Sign in succeeded")
                } else {
                    print("Nah need to confirm that email dawg.")
                }
                completion(true, true)

                // User was not confirmed during the signup process.
                // Invoke `confirmSignUp` api to confirm the user if
                // they have the confirmation code. If they do not have the
                // confirmation code, invoke `resendSignUpCode` to send the
                // code again.
                // After the user is confirmed, invoke the `signIn` api again.
            } else if case .done = nextStep {
                // Use has successfully signed in to the app
                print("Signin complete")
                completion(true, false)
                
                DispatchQueue.main.async {
                    self.isSignedIn = signInResult.isSignedIn
                }

                if signInResult.isSignedIn {
                    print("Sign in succeeded")
                }
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
            completion(false, false)
        } catch {
            print("Unexpected error: \(error)")
            completion(false, false)
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
    
    func resendConfirmationCode(for username: String) async -> Bool {
        do {
            let _ = try await Amplify.Auth.resendSignUpCode(for: username)
            print("Resend code successfully sent")
            return true
        } catch let error as AuthError {
            print("An error occurred while resending confirmation code \(error)")
            return false
        } catch {
            print("Unexpected error: \(error)")
            return false
        }
    }
    
    func resetPassword(username: String, completion: @escaping (Bool) -> Void) async {
        do {
            let resetResult = try await Amplify.Auth.resetPassword(for: username)
            switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                    print("Confirm reset password with code send to - \(deliveryDetails) \(String(describing: info))")
                case .done:
                    print("Reset completed")
            }
            completion(true)
        } catch let error as AuthError {
            print("Reset password failed with error \(error)")
            completion(false)
        } catch {
            print("Unexpected error: \(error)")
            completion(false)
        }
    }
    
    func confirmResetPassword(username: String, newPassword: String, confirmationCode: String, completion: @escaping (Bool) -> Void) async {
        do {
            try await Amplify.Auth.confirmResetPassword(
                for: username,
                with: newPassword,
                confirmationCode: confirmationCode
            )
            print("Password reset confirmed")
            completion(true)
        } catch let error as AuthError {
            print("Reset password failed with error \(error)")
            completion(false)
        } catch {
            print("Unexpected error: \(error)")
            completion(false)
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


class MockAuthService: AuthServiceProtocol {
    @Published var isSignedIn: Bool = true
    @Published var isSignedUp: Bool = true
    @Published var isConfirmed: Bool = true
    @Published var signUpRequested: Bool = true

    init() {
        // Mock initialization
    }

    func fetchCurrentAuthSession() async {
        // Mock fetching auth session
        DispatchQueue.main.async {
            self.isSignedIn = true
        }
    }
    
    func fetchUserEmail() async throws -> String? {
        // Mock fetching user email
        return "mockuser@example.com"
    }

    func signIn(username: String, password: String, completion: @escaping (Bool, Bool) -> Void) async {
        // Mock sign in
        completion(true, false)
    }
    
    func signUp(username: String, email: String, password: String) async -> Bool {
        // Mock sign up
        return true
    }
    
    func confirmSignUp(for username: String, with confirmationCode: String) async -> Bool {
        // Mock confirm sign up
        return true
    }
    
    func resendConfirmationCode(for username: String) async -> Bool {
        // Mock resend confirmation code
        return true
    }
    
    func resetPassword(username: String, completion: @escaping (Bool) -> Void) async {
        // Mock reset password
        completion(true)
    }
    
    func confirmResetPassword(username: String, newPassword: String, confirmationCode: String, completion: @escaping (Bool) -> Void) async {
        // Mock confirm reset password
        completion(true)
    }

    func signOutLocally() async {
        // Mock sign out locally
    }
}

