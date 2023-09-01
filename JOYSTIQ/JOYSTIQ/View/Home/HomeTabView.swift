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
                    
        
                    //--------------START HEADER------------------
                    
                    HStack(spacing: 0) {  //HStack for Header (noti bell - Logo - Messenger)
                        
                        //TEST FOR NAV LINK
                        NavigationLink(destination: NotificationTabView()) {
                            
                            Image(systemName: "bell.fill")
                                .resizable()
                                .frame(width: 22, height: 22)
                                .padding(.leading, 20)
                                .foregroundColor(Color("LightGray"))
                                
                            
                        }
                        

                        
                        Spacer()
                        
                        
                        Button(action: {
                            
                            //open drop down menu
                            // bool modal?
                            showDropDown.toggle()
                            
                        }) {
                            Image("JS_Logo2")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                                .padding(.leading, 5)
                                .padding(.bottom, 10)
                                .padding(.top, 5)
                        }
                         

                        
                        Spacer()
                        
                        //MESSENGER
                        Button(action: {}) {
                            Image(systemName: "tray.full.fill")
                                .resizable()
                                .frame(width: 31, height: 22)
                                .foregroundColor(Color.clear)
                                .padding(.trailing, 20)
                            
                        }
                        
                        
                        
                    } // END HSTACK with Header
                    .frame(height: 65)
                    //.background(Color("Black3"))
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("GradientLight"), Color("GradientDark")]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    //bottom green border
                    .overlay(
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: UIScreen.main.bounds.width, height: 1),
                            alignment: .bottom
                            
                    )
                    
                    //--------------END HEADER------------------
                    
                    
                    
                    //START Feed View. ScrollView for posts.
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        //top padding for first post
                        Rectangle()
                            .foregroundColor(Color("Black0"))
                            .frame(height: 1)
                        
                        
                        //iterate through post list and display each
                        ForEach(1..<4) { i in
                            
                            VStack(spacing: 0) {
                               
                                //needs pfp, username, game name
                                UserBannerPostView(intVal: i)
                                        
                                //needs content and caption
                                PostContentView(intVal: i)
                                
                                //needs [like count, isLiked boolean, comment count, comments]
                                //possible UPID for report
                                //needs showCommentSection bool, showingReportAlert bool
                                InteractionButtonMenu(showCommentSection: $showCommentSection, showingReportAlert: $showingReportAlert)

                         
                                
                            } //end main Vstack for post
                            .background(Color("Black0"))
                            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color("CustomGray")), alignment: .bottom)
                            
                            
                            
                        } //end for each
                            
                      
                        
                    } // END scroll view for home content
                    .background(Color("Black0")) // Fills gap? for each post
                    //.disabled(showDropDown)
                    //.disabled(showCommentSection)
                    

                } //END Vstack with headerview and feed view
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
                   Color.black.opacity(0.5)
                       .edgesIgnoringSafeArea(.all)
                       .onTapGesture {
                           showDropDown = false
                       }
                   
                   DropDownView(showDropDown: $showDropDown)
                    
                   
                } //END If showdropdown
                // --------------------END MODAL-------------------
                
                
                           
            } //END ZStack with Header/feed + DropDown + Comments
            //create custom thank you alert for feedback submission
            
        } //end nav view
            

        
    }
    
}


struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView(showCommentSection: .constant(false))
    }
}
