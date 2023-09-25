//
//  LaunchScreen.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/19/23.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("Black3")
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Image("LaunchScreenLogo3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.5) // Adjusts the width to be 50% of the screen width

                    Text("Loading...")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
