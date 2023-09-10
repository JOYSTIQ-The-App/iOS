//
//  NotificationView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 5/4/23.
//

import SwiftUI

struct NotificationTabView: View {

    
    let sampleNotis = [
        "User123 liked your post.",
        "Nadeshot started following you.",
        "You've earned a gold trophy for reaching 1M followers!",
        "User456 liked your post.",
        "Tarik commented \"Mid + ratio + you're a beta\"",
        "User789 liked your post.",
        "User123 liked your post.",
        "User123 liked your post.",
        "Nadeshot started following you.",
        "You've earned a gold trophy for reaching 1M followers!",
        "User456 liked your post.",
        "Tarik commented \"Mid + ratio + you're a beta\"",
        "User789 liked your post.",
        "User123 liked your post."
    ]
    
    let notiTypes = [
        "post",
        "user",
        "medal",
        "user",
        "user",
        "post",
        "post",
        "post",
        "user",
        "medal",
        "user",
        "user",
        "post",
        "post"
    ]
    
    

    
    
    var body: some View {
        
        VStack (spacing: 0) {
      
   
            //scrollview for displaying notifications
            ScrollView(.vertical, showsIndicators: false) {

            

                ForEach(sampleNotis.indices, id: \.self) { index in
                    
                    NotiView(notificationMessage: sampleNotis[index], notiType: notiTypes[index])
                    
                }

                
            } //end scrollview for displaying notifications
            .frame(width: UIScreen.main.bounds.width)
            .padding(.top, 10)
            .overlay(
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color("GradientDark2"), Color("GradientLight2")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: UIScreen.main.bounds.width, height: 1),
                    alignment: .top
                    
            )
            


            
        } //END MAIN Vstack
        //.edgesIgnoringSafeArea(.all)
        .frame(width: UIScreen.main.bounds.width)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("GradientLight"), Color("GradientDark3")]),
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

