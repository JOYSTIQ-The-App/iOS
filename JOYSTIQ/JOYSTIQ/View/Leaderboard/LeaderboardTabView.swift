//
//  NewsView.swift
//  JOYSTIQ
//
//  Created by cs dev on 4/10/23.
//

import SwiftUI
import AVKit

struct LeaderboardTabView<UserServiceType: UserServiceProtocol>: View {
    var userService: UserServiceType
    
    @State private var showDropDown = false
    
    @State private var showingReportAlert = false
    
    //From app view, comments need to overlay nav bar
    @Binding var showCommentSection: Bool
    
    var body: some View {
        
        NavigationView { //start nav view
            
            ZStack { //for leaderboard and drop down menu
                
                VStack(spacing: 0) { //Main VStack
                    
                    HeaderView(showDropDown: $showDropDown)
                    
                    //START Feed View. ScrollView for posts.
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        
                        //iterate through post list and display each
                        ForEach(1..<11) { i in
                            
                            LazyVStack(spacing: 0) {
                                LeaderboardBanners(placeValue: i)
                                    .padding(.bottom, 5)
                               
                                //needs pfp, username, game name
                                UserBannerPostView(userService: userService, intVal: 1, userId: 1)
                                        
                                //needs content and caption
//                                PostContentView(intVal: i)
                                
                                //needs [like count, isLiked boolean, comment count, comments]
                                //possible UPID for report
                                //needs showCommentSection bool, showingReportAlert bool
                                InteractionButtonMenu(showCommentSection: $showCommentSection, showingReportAlert: $showingReportAlert)
                         
                                
                            } //end main Vstack for post
                            .background(Color("GradientDark3"))
                            
                        } //end for each
                            
                     
                    } // END scroll view for home content
                    .background(Color("GradientDark3")) // Fills gap? for each post
                          
                    
                } //END Main VStack
                //alert for report post
                .alert(isPresented: $showingReportAlert) {
                    Alert(
                        title: Text("Report Post"),
                        message: Text("Are you sure you would like to report this post for violating JOYSTIQ terms and conditions?"),
                        primaryButton: .default(Text("Report"), action: {
                            //makeAPICall() - provide post ID
                        }),
                        secondaryButton: .cancel(Text("Cancel"))
                    )
                }
                
                // ------------------START Drop Down View---------------------
                if showDropDown {
                    
                    //create a shadow effect on the background. click backround to exit
                    Color.black.opacity(0.6)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showDropDown = false
                        }
                    
                    
                    DropDown2(feedbackService: FeedbackService(), showDropDown: $showDropDown)
                    
                } //END If showdropdown
                // --------------------END Drop Down View-------------------
                
                
            } //end ZStack for leaderboard and drop down menu
            
            
            
            
        }//end nav view
        
    } //END BODY
    
}


struct LeaderboardTabView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardTabView(userService: MockUserService(), showCommentSection: .constant(false))
    }
}
