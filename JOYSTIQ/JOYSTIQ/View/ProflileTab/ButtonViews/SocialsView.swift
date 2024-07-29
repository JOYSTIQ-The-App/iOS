//
//  SocialsView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/2/23.
//

import Foundation
import SwiftUI

struct SocialsView: View {
    
    @State var userSocials: [String: String]?
    @Binding var showSocials: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack {
                
                Image("socials")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: ScreenUtil.width , height: ScreenUtil.height * 0.025)
                    //.padding(.bottom, 20)
                
                Divider()
                    .frame(width: ScreenUtil.width * 0.5, height: 1)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("GradientDark"), Color("GradientLight"), Color("GradientDark")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .padding(.bottom, 10)
  
                if let socials = userSocials, !socials.isEmpty {
                    ForEach(socials.keys.sorted(), id: \.self) { key in
                        
                        HStack {
                            
                            
                            Image(key + "Logo")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(Color("LightGray"))
                                .cornerRadius(5)
                            
                            
                            Text(socials[key] ?? "")
                                .font(.system(size: ScreenUtil.width * 0.04))
                                .foregroundColor(Color("LightGray"))
                            
                            Spacer()
                            
                        } //end Socials HStack
                        .padding(.horizontal, 30)
                    }//end for each
                }
                
                else {
                    Text("No socials available.")
                        .foregroundColor(Color("LightGray"))
                }
            }
            .padding(.top, 15)
            
            Button(action: {
                showSocials.toggle()
            }, label: {
                
                Text("Close")
                    .foregroundColor(.white)
                    .frame(width: ScreenUtil.width * 0.2, height: ScreenUtil.height * 0.04)
                    .background(Color.gray.opacity(0.9))
                    .cornerRadius(30)
            })
            .contentShape(Rectangle()) // This makes the entire frame tappable
            .padding(.vertical, 20)

        }
        .frame(width: ScreenUtil.width * 0.7)
        .frame(minHeight: ScreenUtil.height * 0.2)
        .background(Color("GradientDark3"))
        .cornerRadius(10)
        .shadow(color: Color("GradientLight").opacity(0.7), radius: 4, x: 2, y: 2)
        .shadow(color: Color("GradientLight").opacity(0.7), radius: 4, x: -2, y: -2)
        .padding(.bottom, ScreenUtil.height * 0.2)
    }
}

struct SocialsView_Previews: PreviewProvider {
    
    static let mockSocials: [String: String]? = ["discord": "Joystiq_dev", "twitch": "Joystiq_live", "xbox": "Joystiq_Xbox", "kick": "cotts", "playstation": "cotts", "youtube": "NormalName"]
    static let nilSocials: [String: String]? = nil

    static var previews: some View {
        Group {
            SocialsView(userSocials: mockSocials, showSocials: .constant(true))
                .previewDisplayName("With Socials")

            SocialsView(userSocials: nilSocials, showSocials: .constant(true))
                .previewDisplayName("Without Socials")
        }
    }
}
