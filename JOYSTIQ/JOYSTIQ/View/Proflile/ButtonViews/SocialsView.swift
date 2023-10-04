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
                Image(systemName: "person.3.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color("LightGray"))
                
                if let socials = userSocials, !socials.isEmpty {
                    ForEach(socials.keys.sorted(), id: \.self) { key in
                        HStack {
                            Text(key.capitalized)
                                .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                .foregroundColor(Color("LightGray"))
                                .padding(.trailing, 10)
                            
                            Text(socials[key] ?? "")
                                .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                .foregroundColor(Color("LightGray"))
                        }
                    }
                } else {
                    Text("No socials available.")
                        .foregroundColor(Color("LightGray"))
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
            
            Spacer()
            
            Button(action: {
                showSocials.toggle()
            }, label: {
                Text("Close")
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: UIScreen.main.bounds.width * 0.20, height: 40)
                    .background(.gray.opacity(0.8))
                    .cornerRadius(10)
            })
            .contentShape(Rectangle())
            .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.3)
        .background(.black)
        .cornerRadius(10)
        .shadow(color: Color.green.opacity(0.5), radius: 5, x: 2, y: 2)
        .shadow(color: Color.green.opacity(0.5), radius: 5, x: -2, y: -2)
        .padding(.bottom, UIScreen.main.bounds.height * 0.2)
    }
}

struct SocialsView_Previews: PreviewProvider {
    static let mockSocials: [String: String]? = ["discord": "Joystiq_dev", "twitch": "Joystiq_live", "xbox": "Joystiq_Xbox"]
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
