//
//  HeaderView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 5/4/23.
//

import SwiftUI

struct HeaderView: View {
    
    @State private var isShowingNotificationView = false
    @State private var isShowingPopup = false
    @State private var feedbackText = ""
    
    var body: some View {
        
        //ZStack {
            
            HStack(spacing: 0) {  //HStack for noti bell - Logo - Messenger
                
                Button(action: {
                    withAnimation {
                        isShowingNotificationView.toggle()
                    }
                }) {
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
                    
                }) {
                    Image("JS_Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                        .foregroundColor(.green)
                        .padding(.leading, 5)
                        .padding(.bottom, 10)
                        .padding(.top, 5)
                }
                 
                
                
                
                Spacer()
                
                
                Button(action: {}) {
                    Image(systemName: "tray.full.fill")
                        .resizable()
                        .frame(width: 31, height: 22)
                        .foregroundColor(Color("Black0"))
                        .padding(.trailing, 20)
                }
            } // END HSTACK with Header
            .frame(height: 65)
            .background(Color("Black0"))
            //bottom green border
            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color.green), alignment: .bottom)
           
            
            
            // Sliding noti view
            /*
                if isShowingNotificationView {
                    NotificationView(isShowingNotificationView: $isShowingNotificationView)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                        .transition(.move(edge: .leading))
                }
            */
            
        //} //END Zstack with header and noti window
        

        
    }
    
    func submitFeedback() {
            // Perform your logic to handle the submitted feedback here
            // You can access the feedback text using the `feedbackText` property
        }
    
}


struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
