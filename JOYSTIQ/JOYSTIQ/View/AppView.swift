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
    
    @State private var showDropDown = false
    @State private var selectedTab = 0
    @State private var showPostScreen = false
    @State private var hideNavBar = false
    @State private var contentOpacity: Double = 1.0
    
    @State var homeTabToken: UUID = UUID()
    @State var leaderboardTabToken: UUID = UUID()
    
    private let playerManager = PlayerManager()

    // MARK: - Body
    var body: some View {
        ZStack {
            mainContent
                .onChange(of: selectedTab) { _ in
                    contentOpacity = 1.0
                }

            if !hideNavBar {
                VStack {
                    Spacer()
                    navBar
                        .frame(height: UIScreen.main.bounds.height * 0.1)
                }
                .edgesIgnoringSafeArea(.bottom)
            }

        }
        .environmentObject(playerManager)
    }

    
    // MARK: - Subviews
    private var mainContent: some View {
        switch selectedTab {
        case 0:
            return AnyView(
                ZStack {
                    VStack(spacing: 0) {
                        HomeTabView(apiService: apiService, opacity: $contentOpacity)
                            .environmentObject(user)
                            .id(homeTabToken)
                    }
                }
            )
        case 1:
            return AnyView(
                ZStack {
                    VStack(spacing: 0) {
                        LeaderboardTabView(apiService: apiService)
                            .environmentObject(user)
                            .id(leaderboardTabToken)
                    }
                }
            )
        case 3:
            return AnyView(
                ConnectTabView(apiService: apiService)
            )
        case 4:
            return AnyView(
                ProfileTabView<APIServiceType, AuthServiceType>(apiService: apiService, hideNavBar: $hideNavBar)
                    .environmentObject(user)
                    .environmentObject(authService)
            )
        default:
            return AnyView(
                ZStack {
                    VStack(spacing: 0) {
                        HomeTabView(apiService: apiService, opacity: $contentOpacity)
                            .environmentObject(user)
                            .id(homeTabToken)
                    }
                }
            )
        }
    }
    
    private var header: some View {
        HeaderView(showDropDown: $showDropDown, onRefreshPress: {
            refreshPosts()
        })
    }
    
    private var dropDownView: some View {
        ZStack {
            if showDropDown {
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { showDropDown = false }
                
                DropDown2(feedbackService: FeedbackService(), showDropDown: $showDropDown)
            }
        }
    }
    
    private var navBar: some View {
        VStack(spacing: 0) {  // ensure no spacing between the VStack's contents
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("GradientDark2"), Color("GradientLight2")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: UIScreen.main.bounds.width, height: 1)
                .opacity(contentOpacity)

            HStack(spacing: 0) {
                Spacer()
                homeButton
                Spacer()
                leaderboardButton
                Spacer()
                connectButton
                Spacer()
                profileButton
                Spacer()
            }
            .opacity(contentOpacity)
            .frame(width: UIScreen.main.bounds.width, height: 45)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color("GradientDark"), Color("GradientDark3")]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .opacity(contentOpacity)
            )
        }
    }


    
    private var homeButton: some View {
        Button(action: {
            self.selectedTab = 0
        }, label: {
            Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.10, height: 22)
                .foregroundColor(Color.white)
                .padding()
                .cornerRadius(12)
                .shadow(color: selectedTab == 0 ? Color.white.opacity(0.5) : Color.clear, radius: 8, x: 0, y: 0)
        })
    }
    
    private var leaderboardButton: some View {
        Button(action: {
            self.selectedTab = 1
        }, label: {
            Image(systemName: selectedTab == 1 ? "trophy.fill" : "trophy")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.12, height: 24)
                .foregroundColor(Color.white)
                .padding()
                .cornerRadius(12)
                .shadow(color: selectedTab == 1 ? Color.white.opacity(0.5) : Color.clear, radius: 8, x: 0, y: 0)
        })
    }
    
    private var connectButton: some View {
        Button(action: {
            self.selectedTab = 3
        }, label: {
            Image(systemName: selectedTab == 3 ? "magnifyingglass" : "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.11, height: 21)
                .foregroundColor(Color.white)
                .padding()
                .cornerRadius(12)
                .shadow(color: selectedTab == 3 ? Color.white.opacity(0.5) : Color.clear, radius: 8, x: 0, y: 0)
        })
    }
    
    private var profileButton: some View {
        Button(action: {
            self.selectedTab = 4
        }, label: {
            Image(systemName: selectedTab == 4 ? "person.fill" : "person")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.11, height: 24)
                .padding()
                .foregroundColor(Color.white)
                .shadow(color: selectedTab == 4 ? Color.white.opacity(0.5) : Color.clear, radius: 8, x: 0, y: 0)
        })
    }
    
    //MARK: - Functions
    private func refreshPosts() {
        if selectedTab == 0 {
            homeTabToken = UUID()
            return
        }
        
        if selectedTab == 1 {
            leaderboardTabToken = UUID()
            return
        }
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
