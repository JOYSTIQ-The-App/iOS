//
//  ProfileSettingsView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/10/23.
//

import SwiftUI

struct ProfileSettingsView<APIServiceType: APIServiceProtocol, AuthServiceType: AuthServiceProtocol & ObservableObject>: View {
    
    // MARK: - Properties
    var apiService: APIServiceType
    @EnvironmentObject var authService: AuthServiceType
    @EnvironmentObject var user: User
    @Binding var hideNavBar: Bool
    
    @State private var showingLogoutAlert = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            contentList
            Spacer()
            logoutButton
                .padding(.bottom, 20)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Settings")
        .onAppear{
            hideNavBar = true
        }
        .alert(isPresented: $showingLogoutAlert) {
            Alert(title: Text("Logout"),
                  message: Text("Are you sure you want to logout?"),
                  primaryButton: .default(Text("Yes"), action: performLogout),
                  secondaryButton: .cancel())
        }
        .preferredColorScheme(.dark) // Force dark mode
    }
    
    // MARK: - Subviews
    private var contentList: some View {
        List {
            profileSection
        }
    }
    
    private var profileSection: some View {
        Section(header: Text("Profile")) {
            bioNavigationLink
            socialsNavigationLink
            usernameNavigationLink
        }
    }
    
    private var bioNavigationLink: some View {
        NavigationLink(destination: EditBioView(apiService: apiService)) {
            HStack {
                Image(systemName: "person.crop.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color(.label))
                    .padding(.trailing, 5)
                
                Text("Bio")
            }
        }
    }
    
    private var socialsNavigationLink: some View {
        NavigationLink(destination: EditSocialsView(apiService: apiService)) {
            HStack {
                Image(systemName: "network")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color(.label))
                    .padding(.trailing, 5)
                
                Text("Socials")
            }
        }
    }
    
    private var usernameNavigationLink: some View {
        NavigationLink(destination: EditUsernameView(apiService: apiService)) {
            Text("Change Username")
        }
    }
    
    private var logoutButton: some View {
        Button(action: {
            showingLogoutAlert = true
        }) {
            Text("Logout")
                .foregroundColor(.red)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: - Functions
    private func performLogout() {
        Task {
            await authService.signOutLocally()
            await authService.fetchCurrentAuthSession()
        }
    }
}

// MARK: - Preview
struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "Apical")
        
        return ProfileSettingsView<MockAPIService, MockAuthService>(apiService: MockAPIService(), hideNavBar: .constant(true))
            .environmentObject(testUser)
            .environmentObject(MockAuthService())
    }
}
