//
//  LaunchScreen.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/19/23.
//

import SwiftUI

struct LaunchScreenView: View {
   
    var body: some View {
        
            VStack(spacing: 20) {
                Image("LaunchScreenLogoAtt4")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.3)
                    //.frame(width: geometry.size.width * 0.5) // Adjusts the width to be 50% of the screen width

                Image("loading3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.18)
                    .padding(.leading, UIScreen.main.bounds.width * 0.04)
            }
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color("GradientDark3"), Color("GradientLight")]),
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            )
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
