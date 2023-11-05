//
//  ImageViewer.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 10/1/23.
//

import SwiftUI

struct ImageViewer: View {
    
    @State private var isFullScreen = false
    @State private var imageOffset: CGSize = .zero
    @State private var dragOffset: CGFloat = 0
    
    
    var body: some View {
    //private var imageContent: some View {
        
        VStack(alignment: .center) {
            imagePostView
                .fullScreenCover(isPresented: $isFullScreen) {
                    imageFullScreenViewer
                }
            
            
        }
        .frame(width: UIScreen.main.bounds.width)

        
    }
    
    
    private var imagePostView: some View {
   
 
        ZStack(alignment: .bottomTrailing) {
            
            Image("portrait")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .frame(minHeight: UIScreen.main.bounds.height * 0.2, maxHeight: UIScreen.main.bounds.height * 0.3)
                .cornerRadius(10)
                .zIndex(0)
            
            Button(action: {
                self.isFullScreen.toggle()
            }) {
            
                ZStack() {
                    
                    Image(systemName: "app")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color("LightGray"))
                    
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(Color("LightGray"))
                    
                }
                .background(Color.black.opacity(0.6))
                .cornerRadius(10)
                
                                           
            }
            .frame(width: 35, height: 35)
            .padding(.bottom, 10)
            .padding(.trailing, 10)
            .zIndex(1)
            
 
            
        }
            
      
        
    }
    
    private var imageFullScreenViewer: some View {
            
        VStack(spacing: 0) {
            actionMenu
            Spacer()
          
                Image("portrait")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            
            
            Spacer()
        } //end VStack
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.black)
        .offset(y: max(-20, imageOffset.height + dragOffset))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    dragOffset = max(0, gesture.translation.height)
                }
                .onEnded { gesture in
                    if dragOffset > 100 {
                        withAnimation {
                            isFullScreen = false
                            imageOffset = .zero
                            dragOffset = 0
                        }
                    } else {
                        // Reset the dragOffset if the drag didn't reach the threshold
                        withAnimation {
                            dragOffset = 0
                        }
                    }
                }
        )
    }
    
    private var actionMenu: some View {
        HStack { //for close and ...
            
            Spacer()
            
            Button(action: {
                isFullScreen = false
            }) {
            
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("LightGray"))
                                   
            }
            
        }//end HStack for action menu
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 30)
        .padding(.top, 30)
    }
    
    
    
    
}

struct ImageViewer_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewer()
    }
}
