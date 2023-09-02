//
//  NotificationView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 5/4/23.
//

import SwiftUI

struct NotificationTabView: View {

    
    let sampleNotis = [
        "User123 liked your post",
        "Nadeshot started following you",
        "You've earned a gold trophy for reaching 1M followers!",
        "User456 liked your post",
        "Nooch commented \"Mid + ratio + you're a beta\"",
        "User789 liked your post",
        "User123 liked your post"
    ]
    
    let notiTypes = [
        "post",
        "user",
        "medal",
        "user",
        "user",
        "post",
        "post"
    ]
    
    

    
    
    var body: some View {
        
        VStack {
      
            Image("NotificationsText")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 30)
                .padding(.top, UIScreen.main.bounds.height * 0.08)

            Divider()
                .background(.green)
            
            
            //scrollview for displaying notifications
            ScrollView(.vertical, showsIndicators: false) {
                

                ForEach(sampleNotis.indices, id: \.self) { index in
                    
                    NotiView(notificationMessage: sampleNotis[index], notiType: notiTypes[index])
                    
                }

                
            } //end scrollview for displaying notifications
            .frame(width: UIScreen.main.bounds.width)
            
            Spacer()

            
        } //END MAIN Vstack
        .edgesIgnoringSafeArea(.all)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        //.background(Color("Black0"))
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("GradientLight"), Color("GradientDark")]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        
    } //END body
    
}


struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationTabView()
    }
}

