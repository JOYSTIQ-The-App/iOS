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
        VStack() {
            profileSettings
            Spacer()
        }
        .frame(width: ScreenUtil.width, height: ScreenUtil.height)
        .background(Color("GradientDark3"))
    }
    
    // MARK: - Subviews
    private var profileSettings: some View {
        VStack {
            usernameNavigationLink
            divider
            bioNavigationLink
            divider
            socialsNavigationLink
            divider
            logoutButton
        }
        .frame(width: ScreenUtil.width * 0.9)
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.top, ScreenUtil.height * 0.1)
        .onAppear{
            hideNavBar = true
        }
        .alert(isPresented: $showingLogoutAlert) {
            Alert(title: Text("Logout"),
                  message: Text("Are you sure you want to logout?"),
                  primaryButton: .default(Text("Yes"), action: performLogout),
                  secondaryButton: .cancel())
        }
    }
    
    private var usernameNavigationLink: some View {
        NavigationLink(destination: EditUsernameView(apiService: apiService).navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Update Username")
                        .font(.system(size: 18))
                        .foregroundColor(Color("LightGray"))
                }
            }) {
            HStack(spacing: 0) {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: ScreenUtil.width * 0.05, height: ScreenUtil.width * 0.05)
                    .foregroundColor(Color("LightGray"))
                    .padding(.trailing, ScreenUtil.width * 0.04)
                
                Text("Username")
                    .foregroundColor(Color("LightGray"))
                    .font(.system(size: ScreenUtil.width * 0.04))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: ScreenUtil.width * 0.03, height: ScreenUtil.width * 0.03)
                    .foregroundColor(Color("LightGray"))

            }
            .padding(.vertical, ScreenUtil.width * 0.012)
            .padding(.horizontal, ScreenUtil.width * 0.04)
        }
    }
    
    private var bioNavigationLink: some View {
        NavigationLink(destination: EditBioView(apiService: apiService).toolbar {
            ToolbarItem(placement: .principal) {
                Text("Update Bio")
                    .font(.system(size: 18))
                    .foregroundColor(Color("LightGray"))
            }
        }) {
            HStack(spacing: 0) {
                Image(systemName: "text.bubble")
                    .resizable()
                    .scaledToFit()
                    .frame(width: ScreenUtil.width * 0.05, height: ScreenUtil.width * 0.05)
                    .foregroundColor(Color("LightGray"))
                    .padding(.trailing, ScreenUtil.width * 0.04)
                
                Text("Bio")
                    .foregroundColor(Color("LightGray"))
                    .font(.system(size: ScreenUtil.width * 0.04))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: ScreenUtil.width * 0.03, height: ScreenUtil.width * 0.03)
                    .foregroundColor(Color("LightGray"))
                
            }
            .padding(.vertical, ScreenUtil.width * 0.012)
            .padding(.horizontal, ScreenUtil.width * 0.04)
        }
    }
    
    private var socialsNavigationLink: some View {
        NavigationLink(destination: EditSocialsView(apiService: apiService).toolbar {
            ToolbarItem(placement: .principal) {
                Text("Add Socials")
                    .font(.system(size: 18))
                    .foregroundColor(Color("LightGray"))
            }
        }) {
            HStack(spacing: 0) {
                Image(systemName: "person.crop.rectangle.stack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: ScreenUtil.width * 0.05, height: ScreenUtil.width * 0.05)
                    .foregroundColor(Color("LightGray"))
                    .padding(.trailing, ScreenUtil.width * 0.04)
                
                Text("Socials")
                    .foregroundColor(Color("LightGray"))
                    .font(.system(size: ScreenUtil.width * 0.04))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: ScreenUtil.width * 0.03, height: ScreenUtil.width * 0.03)
                    .foregroundColor(Color("LightGray"))

            }
            .padding(.vertical, ScreenUtil.width * 0.012)
            .padding(.horizontal, ScreenUtil.width * 0.04)
        }
    }
    
    private var logoutButton: some View {
        Button(action: {
            showingLogoutAlert = true
        }) {
            HStack(spacing: 0) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: ScreenUtil.width * 0.05, height: ScreenUtil.width * 0.05)
                    .foregroundColor(Color.red)
                    .padding(.trailing, ScreenUtil.width * 0.035)
                
                Text("Logout")
                    .foregroundColor(Color.red)
                    .font(.system(size: ScreenUtil.width * 0.04))
                
                Spacer()

            }
            .padding(.vertical, ScreenUtil.width * 0.012)
            .padding(.horizontal, ScreenUtil.width * 0.05)

        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var divider: some View {
        HStack {
            Spacer()
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("LightGray").opacity(0.1))
                .frame(width: ScreenUtil.width * 0.775)
        }
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
