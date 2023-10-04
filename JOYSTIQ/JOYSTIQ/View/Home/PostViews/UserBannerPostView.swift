//
//  UserBannerPostView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 5/4/23.
//
// Takes in profile picture (png), username (string), game name (string ?)
//

import SwiftUI

struct UserBannerPostView<APIServiceType: APIServiceProtocol>: View {
    var APIService: APIServiceType
    
    @State public var intVal: Int
    @State private var username: String = "Loading..."
    
    var userId: Int
    
    var body: some View {
        
        HStack() { // HStack for username + banner and game title button
            
            ZStack(alignment: .leading) { //ZStack for user picture and username banner
                
                /*
                 DEFAULT Image
                 
                Image(systemName: "person") // Replace "profile_picture" with user avatar snapshot
                    .frame(width: 55, height: 55)
                    .font(.system(size: 40))
                    .foregroundColor(.black)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 3))
                    .background(Circle().foregroundColor(.green))
                    .zIndex(1)
                */
                
                Image("TestAvatar4")
                    .frame(width: 45, height: 45)
                    .scaleEffect(0.25)
                    .foregroundColor(.black)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .zIndex(1)
                
                    
                
                Text(username)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width * 0.30, height: 30)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white, Color.gray]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                    .cornerRadius(10)
                    .zIndex(0)
                    .padding(.leading, 30)
                    
          
            } //Zstack for user banner
            .frame(width: UIScreen.main.bounds.width * 0.4, height: 50)
            .padding(.leading, 10)
            

                 
            
            //Game title button that features logo of game
            Button(action: {
                // this button may bring users to specific game content
            }) {
                Image("Logo" + String(intVal))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .cornerRadius(10)
                    
            }
            
            Spacer()
            
            
        } //END HStack for pfp + username banner + game title
        .frame(width: UIScreen.main.bounds.width)
        .background(Color("GradientDark3"))
        .onAppear {
            getUsername()
        }
        
    } //END Body
    
    
    func getUsername() {
        let userIdentifier: UserIdentifier = .userId(userId)
        APIService.getUsername(for: userIdentifier) { result in
            switch result {
            case .success(let fetchedUsername):
                username = fetchedUsername
            case .failure(let error):
                print("Error getting username: \(error.localizedDescription)")
            }
        }
    }

    
}


struct UserBannerPostView_Previews: PreviewProvider {
    static var previews: some View {
        UserBannerPostView<MockAPIService>(APIService: MockAPIService(), intVal: 1, userId: 1)
    }
}

