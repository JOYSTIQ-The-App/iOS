//
//  NotificationView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 5/4/23.
//

import SwiftUI

struct NotificationTabView: View {
    
    
    var body: some View {
        
        VStack {
          
            Text("Notifications")
                .font(.title2)
                .foregroundColor(.green)
                .padding(.top, UIScreen.main.bounds.height * 0.1)
            
            Divider()
                .background(.green)
            
            
            //scrollview for displaying notifications
            ScrollView(.vertical, showsIndicators: false) {
                
                ForEach(0..<10) { i in
                    NotiView()
                    
                }
                
            } //end scrollview for displaying notifications
            .frame(width: UIScreen.main.bounds.width)
            
            Spacer()

            
        } //END MAIN Vstack
        .edgesIgnoringSafeArea(.all)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color("Black0"))
        
    } //END body
    
}


struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationTabView()
    }
}

