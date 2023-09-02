//
//  AppView.swift
//  JOYSTIQ
//
//  This file has code for controlling the view to show based on selected tab
// and code for the navbar. The header with logo and buttons can be found in home file

import SwiftUI

struct AppView: View {
    
    //Tab state to control views based on nav bar interaction
    @State private var selectedTab = 0
    @State private var showPostScreen = false
    
    //Control comment section
    @State private var showCommentSection = false
    
    var body: some View {
            
        ZStack { //for Vstack w/ view and nav and comment section
            
            VStack(spacing: 0) { //Vstack contain view and nav bar
                
                //determine which screen to show
                switch selectedTab {
                    
                case 0:
                    HomeTabView(showCommentSection: $showCommentSection)
                        .disabled(showCommentSection)
                    
                case 1:
                    LeaderboardTabView()
                case 3:
                    ConnectTabView()
                case 4:
                    ProfileTabView()
                default:
                    HomeTabView(showCommentSection: $showCommentSection).disabled(showCommentSection)
                    
                }
                
   
                //Nav Bar hstack
                HStack(spacing: 0) {
                    
                    //Home Button
                    Button(action: {
                        self.selectedTab = 0
                    }, label: {
                        
                        
                        Image(systemName: selectedTab == 0 ? "house.fill" :
                                "house")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.10, height: 22)
                        .foregroundColor(Color("LightGray"))
                        .padding()
                        .cornerRadius(12)
                        .shadow(color: selectedTab == 0 ? Color.white.opacity(0.5) : Color.clear, radius: 16, x: 0, y: 8)
                        
                        
                    })
                    
                    
                    //Leaderboard Button
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
                            .shadow(color: selectedTab == 1 ? Color.white.opacity(0.5) : Color.clear, radius: 16, x: 0, y: 8)
                        
                        
                    })
                    
                    //Post button
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
                            
                        } // END Zstack with for post button
                        .frame(width: UIScreen.main.bounds.width * 0.18, height: 25)
                        
                        
                        
                    })
                    .sheet(isPresented: $showPostScreen) {
                        CreatePostView(isPresented: $showPostScreen)
                    }
                    
                    
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
                            .shadow(color: selectedTab == 3 ? Color.white.opacity(0.5) : Color.clear, radius: 16, x: 0, y: 8)
                            
                        
                    })
                    
                    Button(action: {
                        self.selectedTab = 4
                    }, label: {
                        
                        
                        Image(systemName: selectedTab == 4 ? "person.crop.square.fill" : "person.crop.square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * 0.11, height: 24)
                            .padding()
                            .foregroundColor(Color("LightGray"))
                            .shadow(color: selectedTab == 4 ? Color.white.opacity(0.5) : Color.clear, radius: 16, x: 0, y: 8)
                            
                        
                    })
                    
                 
                    
                } //END HStack for nav bar
                .disabled(showCommentSection)
                .frame(width: UIScreen.main.bounds.width, height: 55)
                //.background(Color.clear)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("GradientDark"), Color("GradientDark3")]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                
                
                //border above nav bar
                .overlay(
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color("GradientDark2"), Color("GradientLight2")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: UIScreen.main.bounds.width, height: 1),
                        alignment: .top
                        
                )
                
                
                 
            } //END MAIN VStack
            //Entire background, behind feed and nav bar
            //.background(Color("Black0"))
            
            
            // ------------------START Comment Section---------------------
            if showCommentSection {
                
                VStack(spacing: 0) {
                    
                    Spacer ()
                    
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showCommentSection = false
                        }
                    
                    CommentSectionView(showCommentSection: $showCommentSection)
                    
                    
                } //END VStack for
                .edgesIgnoringSafeArea(.all)
                
                
            } //end If showCommentSection
            // ------------------END Comment Section---------------------
            
            
        } //end ZStack for Vstack w/ view and nav bar and comment section
        

        
    }
    
    
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
