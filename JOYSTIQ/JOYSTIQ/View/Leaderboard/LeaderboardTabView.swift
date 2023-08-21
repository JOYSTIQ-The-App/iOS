//
//  NewsView.swift
//  JOYSTIQ
//
//  Created by cs dev on 4/10/23.
//

import SwiftUI
import AVKit

struct LeaderboardTabView: View {
    
    var body: some View {
        
        
        VStack(spacing: 0) { //Main VStack
            
            HeaderView()
            
           
            ZStack(alignment: .topTrailing) {
                


                //Scroll view has banners and posts
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 0) {
                        
                        ForEach(1..<11) { i in
                            
                            LeaderboardBanners(placeValue: i)
                            
                            //ClipPostView(intValue: i)
                            
                            //-----------------START CONTENT---------------------
                            
                            
                                
                            VStack(spacing: 0) {
                               
                                // Banner
                                
                                UserBannerPostView(intVal: i)
                                
                                
                                 
                                if let videoURL = Bundle.main.url(forResource: "TrimmedClip" + String(i), withExtension: "mp4") {
                                    
                                    let player = AVPlayer(url: videoURL)
                                    
                                    VideoPlayer(player: player)
                                        .frame(width: UIScreen.main.bounds.width-30, height: 220)
                                        .cornerRadius(10)
                                        .padding(.vertical, 10)
                                    
                                } else {
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 230)
                                        .cornerRadius(15)
                                }
                                
                                
                                     
                                
                                // Caption
                                Text("Username: This is a sample caption of a few lines of text. Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, 20)
                                
                                
                                
                                
                                //---------- START INTERACTION BUTTONS -------------------------
                                
                                // Hstack for interaction buttons
                                HStack {
                                    
                                    //pass post UUID to likebutton view
                                    LikeButton(likesCount: Int.random(in: 100...200000))
                                    
                                    Button(action: {
                                        // Handle comment button action
                                        //showCommentSection.toggle()
                                        
                                    }) {
                                        Image(systemName: "message")
                                            .imageScale(.large)
                                    }
                                    
                                    CommentCount(commentCount: Int.random(in: 100...10000))
                                    
                                    
                                    Spacer()
                                    
                                   
                                    
                                 
                                    Menu {
                                        
                                        Button(action: {
                                            //report dialogue
                                            //showingReportAlert = true
                                        }) {
                                            Text("Report Post")
                                        }
                                        
                                    } label: {
                                        
                                        HStack() {
                                            
                                            Image(systemName: "ellipsis")
                                                .imageScale(.large)
                                                .padding(.trailing, 10)
                                            
                                        }
                                        
                                    }
                           
                                    
                                    
                                } //END Hstack for interaction buttons
                                .padding()
                                .padding(.horizontal, 5)
                                .shadow(radius: 2)
                                .zIndex(1)
                            
                                
                                //---------- END INTERACTION BUTTONS -------------------------
                                
                         
                                
                            } //end main Vstack for post
                            .background(Color("Black0"))
                            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color("CustomGray")), alignment: .bottom)
                            
                            
                            LeaderboardBottom(placeValue: i)
                                
                            
                            
                            //------------------END CONTENT----------------------
                            
                        }
                        
                    } //END Vstack for content
                    
                } // END scroll view for home content
 
                
            
                //LeaderboardContentFilter()
                    //.zIndex(1)
              
                
            } //END Zstack containing posts and filter
            .background(Color("Black0"))
            
        } //END Main VStack
        .background(Color("Black1"))
        
    } //END BODY
    
}


struct LeaderboardTabView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardTabView()
    }
}
