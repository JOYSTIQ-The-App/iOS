//
//  SwiftUIView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 4/28/23.
//



import SwiftUI
import AVKit

struct ClipPostView: View {
    
    
    @State private var intValue: Int
    
    //@State private var isFullScreen = false
    @State private var player = AVPlayer()
        
    init(intValue: Int) {
        self._intValue = State(initialValue: intValue)

    }
    
    
    var body: some View {
        
        
        /*
        VStack(spacing: 0) {
           
            // Banner
            
            UserBannerPostView(intVal: intValue)
            
            
             
            if let videoURL = Bundle.main.url(forResource: "TrimmedClip" + String(intValue), withExtension: "mp4") {
                
                let player = AVPlayer(url: videoURL)
                
                VideoPlayer(player: player)
                    .frame(width: UIScreen.main.bounds.width-30, height: 220)
                    .cornerRadius(10)
                
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 250)
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
                
                Button(action: {
                    isLiked = !isLiked
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .accentColor)
                        .imageScale(.large)
                        .padding(.trailing, 10)
                }
                
                
                Button(action: {
                    // Handle comment button action
                    
                }) {
                    Image(systemName: "message")
                        .imageScale(.large)
                }
                
                
                Spacer()
                
                /* Share button
                
                Button(action: {
                    // Handle share button action
                }) {
                    Image(systemName: "arrow.turn.up.right")
                        .imageScale(.large)
                }
                 
                 */
                
             
                Menu {
                    
                    Button(action: {
                        //report dialogue
                        showingReportAlert = true
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
            .alert(isPresented: $showingReportAlert) {
                Alert(
                    title: Text("Report Post"),
                    message: Text("Are you sure you would like to report this post for violating JOYSTIQ terms and conditions?"),
                    primaryButton: .default(Text("Report"), action: {
                        makeAPICall()
                    }),
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
            
            //---------- END INTERACTION BUTTONS -------------------------
            
     
            
        } //end main Vstack for post
        .background(Color("Black0"))
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color("CustomGray")), alignment: .bottom)
        */
        
        Text("PLACE HOLDER").foregroundColor(.red)
        
       
    }
     
    
}


struct ClipPostView_Previews: PreviewProvider {
    static var previews: some View {
        ClipPostView(intValue: 1)
    }
}


