//
//  HomeTabView.swift
//  JOYSTIQ
//
//  Created by cs dev on 4/10/23.
//

import SwiftUI

struct HomeTabView: View {
    
    @State private var showDropDown = false
    
    // FROM INTERACTION BUTTON
    @State private var showingReportAlert = false
    
    //From app view, comments need to overlay nav bar
    @Binding var showCommentSection: Bool
    
    var body: some View {
        
        NavigationView { //start nav view
            
            ZStack { //ZStack for header/feed + dropdown
                
                VStack(spacing: 0){ //START VStack with headerview and feed scrollview
                    
                    HeaderView(showDropDown: $showDropDown)
                    
                    //START Feed View. ScrollView for posts.
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        Rectangle()
                            .foregroundColor(Color("GradientDark3"))
                            .frame(height: 0.01)
                        
                        
                        //iterate through post list and display each
                        ForEach(1..<4) { i in
                            
                            LazyVStack(spacing: 0) {
                               
                                //needs pfp, username, game name
                                UserBannerPostView(intVal: i)
                                        
                                //needs content and caption
                                PostContentView(intVal: i)
                                
                                //needs [like count, isLiked boolean, comment count, comments]
                                //possible UPID for report
                                //needs showCommentSection bool, showingReportAlert bool
                                InteractionButtonMenu(showCommentSection: $showCommentSection, showingReportAlert: $showingReportAlert)

                         
                                
                            } //end main Vstack for post
                            .background(Color("GradientDark3"))
                            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color("LightGray").opacity(0.4)), alignment: .bottom)
                        
                            
                            
                        } //end for each
                            
                      
                        
                    } // END scroll view for home content
                    .background(Color("GradientDark3")) // Fills gap? for each post
                    //.disabled(showDropDown)
                    //.disabled(showCommentSection)
                    

                } //END Vstack with headerview and feed view
                .background(Color("GradientDark3"))
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
                
                

                
                // ------------------START MODAL / Drop Down View---------------------
                 
                if showDropDown {
                   
                   //create a shadow effect on the background. click backround to exit
                    
                   Color.black.opacity(0.6)
                       .edgesIgnoringSafeArea(.all)
                       .onTapGesture {
                           showDropDown = false
                       }
                   
                    
                   DropDown2(showDropDown: $showDropDown)
                        
                    
                   
                } //END If showdropdown
                 
                // --------------------END MODAL-------------------
                
                
                           
            } //END ZStack with Header/feed + DropDown
            
            //create custom thank you alert for feedback submission
            
        } //end nav view
        .accentColor(Color("LightGray"))

        
    }
    
}


struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView(showCommentSection: .constant(false))
    }
}
