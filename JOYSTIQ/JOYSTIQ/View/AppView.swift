//
//  AppView.swift
//  JOYSTIQ
//
//  This file has code for controlling the view to show based on selected tab
// and code for the navbar. The header with logo and buttons can be found in home file

import SwiftUI

struct AppView<APIServiceType: APIServiceProtocol, AuthServiceType: AuthServiceProtocol & ObservableObject>: View {
    // MARK: - Properties
    var apiService: APIServiceType
    @EnvironmentObject var authService: AuthServiceType
    @EnvironmentObject var user: User
    
    @State private var selectedTab = 0
    @State private var showPostScreen = false
    @State private var hideNavBar = false

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            mainContent
            if !hideNavBar {
                navBar
            }
        }
    }
    
    // MARK: - Subviews
    private var mainContent: some View {
        switch selectedTab {
        case 0:
            return AnyView(
                HomeTabView(APIService: apiService)
                    .environmentObject(user)
            )
        case 1:
            return AnyView(
                LeaderboardTabView(APIService: apiService)
                    .environmentObject(user)
            )
        case 3:
            return AnyView(
                ConnectTabView(APIService: apiService)
            )
        case 4:
            return AnyView(
                ProfileTabView<APIServiceType, AuthServiceType>(APIService: apiService, hideNavBar: $hideNavBar)
                    .environmentObject(user)
                    .environmentObject(authService)
            )
        default:
            return AnyView(
                HomeTabView(APIService: apiService)
                    .environmentObject(user)
            )
        }
    }
    
    private var navBar: some View {
        HStack(spacing: 0) {
            homeButton
            leaderboardButton
            postButton
            connectButton
            profileButton
        }
        .frame(width: UIScreen.main.bounds.width, height: 55)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("GradientDark"), Color("GradientDark3")]),
                startPoint: .bottom,
                endPoint: .top
            )
        )
        .overlay(
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("GradientDark2"), Color("GradientLight2")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: UIScreen.main.bounds.width, height: 1),
                alignment: .top
        )
    }
    
    private var homeButton: some View {
        Button(action: {
            self.selectedTab = 0
        }, label: {
            Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.10, height: 22)
                .foregroundColor(Color("LightGray"))
                .padding()
                .cornerRadius(12)
                .shadow(color: selectedTab == 0 ? Color.white.opacity(0.5) : Color.clear, radius: 8, x: 0, y: 0)
        })
    }
    
    private var leaderboardButton: some View {
        Button(action: {
            self.selectedTab = 1
        }, label: {
            Image(systemName: selectedTab == 1 ? "medal.fill" : "medal")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.12, height: 24)
                .foregroundColor(Color("LightGray"))
                .padding()
                .cornerRadius(12)
                .shadow(color: selectedTab == 1 ? Color.white.opacity(0.5) : Color.clear, radius: 8, x: 0, y: 0)
        })
    }
    
    private var postButton: some View {
        Button(action: {
            showPostScreen = true
        }, label: {
            ZStack {
                Image(systemName: "square")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color.green)
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.green)
                    .padding()
                    .cornerRadius(12)
            }
            .frame(width: UIScreen.main.bounds.width * 0.18, height: 25)
        })
        .sheet(isPresented: $showPostScreen) {
            CreatePostView<APIService, AuthService>(APIService: apiService as! APIService, isPresented: $showPostScreen)
                .environmentObject(authService)
        }
    }

    
    private var connectButton: some View {
        Button(action: {
            self.selectedTab = 3
        }, label: {
            Image(systemName: selectedTab == 3 ? "point.3.filled.connected.trianglepath.dotted" : "point.3.connected.trianglepath.dotted")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.11, height: 21)
                .foregroundColor(Color("LightGray"))
                .padding()
                .cornerRadius(12)
                .shadow(color: selectedTab == 3 ? Color.white.opacity(0.5) : Color.clear, radius: 8, x: 0, y: 0)
        })
    }
    
    private var profileButton: some View {
        Button(action: {
            self.selectedTab = 4
        }, label: {
            Image(systemName: selectedTab == 4 ? "person.crop.square.fill" : "person.crop.square")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.11, height: 24)
                .padding()
                .foregroundColor(Color("LightGray"))
                .shadow(color: selectedTab == 4 ? Color.white.opacity(0.5) : Color.clear, radius: 8, x: 0, y: 0)
        })
    }
}

// MARK: - Preview
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "testUsername")
        
        return AppView<MockAPIService, MockAuthService>(apiService: MockAPIService())
            .environmentObject(MockAuthService())
            .environmentObject(testUser)
    }
}
