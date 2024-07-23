//
//  HomeHeaderView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/30/23.
//

import SwiftUI

struct HomeHeaderView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    var apiService: APIServiceType
    @Binding var showDropDown: Bool
    @Binding var selectedFeed: FeedType
    
    @State private var showPostScreen = false

    // MARK: - Body
    var body: some View {
        VStack {
            headerContent
            feedTypePicker
        }
        .background(headerBackground)
    }

    // MARK: - Subviews
    private var headerContent: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Spacer()
                dropdownButton
                Spacer()
            }
            
            createPostButton
                .padding(.trailing, 15)
        }
        .frame(height: 65)
    }

    
    private var dropdownButton: some View {
        Button(action: {
            showDropDown.toggle()
        }) {
            Image("JS_Logo2")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
        .buttonStyle(NeumorphicButtonStyle2())
    }
    
    private var createPostButton: some View {
        Button(action: {
            showPostScreen = true
        }) {
            Image(systemName: "square.and.pencil")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(Color.white)
            
        }
        .sheet(isPresented: $showPostScreen) {
            CreatePostView(apiService: apiService, isPresented: $showPostScreen)
        }
    }
    
    private var headerBackground: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color("GradientLight"), Color("GradientDark")]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var bottomBorder: some View {
        Rectangle()
            .fill(LinearGradient(gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: UIScreen.main.bounds.width, height: 1)
    }
    
    private var feedTypePicker: some View {
        HStack(alignment: .bottom, spacing: 20) {
            Spacer()
            Spacer()
            
            Button(action: {
                selectedFeed = .following
            }) {
                VStack(spacing: 8) {
                    Text("Following")
                        .foregroundColor(selectedFeed == .following ? Color.white : Color.lightGray)
                    
                    Rectangle()
                        .frame(width: 70, height: 2) // You can adjust width as needed
                        .foregroundColor(selectedFeed == .following ? Color.white : Color.gray)
                    
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            Button(action: {
                selectedFeed = .global
            }) {
                VStack(spacing: 8) {
                    Text("Global")
                        .foregroundColor(selectedFeed == .global ? Color.white : Color.lightGray)
                    
                    Rectangle()
                        .frame(width: 70, height: 2) // You can adjust width as needed
                        .foregroundColor(selectedFeed == .global ? Color.white : Color.gray)
                    
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            Spacer()
            Spacer()
        }
    }
}

// MARK: - Previews
struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView<MockAPIService>(apiService: MockAPIService(), showDropDown: .constant(false), selectedFeed: .constant(.following))
    }
}

