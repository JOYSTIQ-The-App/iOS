//
//  AccoladeBanner.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 4/24/23.
//

import SwiftUI

struct AccoladeBanner: View {

    @State private var gameMode = true
    
    //for testing
    var gamesArr = ["valorant", "fortnite", "overwatch", "callofduty", "bloodhunt", "thefinals"]
    
    var body: some View {
        
        ZStack { //for banner image and scroll view
            
            HStack{ //to space banner image to right side
                
                Spacer()
            
                Image("AccBannerAtt2")
                    .resizable()
                    .frame(width: ScreenUtil.width, height: ScreenUtil.height * 0.09)
                    .shadow(color: Color.black, radius: 3, x: 4, y: 4)
                
            } //end Hstack for spacer and image
            
            HStack { //spacer to push scrollview to right
                            
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {

                        switch gameMode{
                            
                        case true:
                            
                            HStack(spacing: ScreenUtil.width * 0.109) { //games list
                                ForEach(Array(gamesArr.enumerated()), id: \.element) { (index, icon) in
                                    Image(icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: ScreenUtil.width * 0.11, height: ScreenUtil.width * 0.11)
                                        .cornerRadius(10)
                                }
                            } //end hstack for games
                            .padding(.top, ScreenUtil.height * 0.01) //lower items in banner
                            .padding(.leading, ScreenUtil.width * 0.09) //for left of first item
                            .padding(.trailing, ScreenUtil.width * 0.074) //for right of last item
                            

                        case false:
                               
                            HStack(spacing: ScreenUtil.width * 0.1) {

                                Image("MedalAlpha")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: ScreenUtil.width * 0.12, height: ScreenUtil.width * 0.14)
                                
                                Image("MedalBeta")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: ScreenUtil.width * 0.12, height: ScreenUtil.width * 0.14)
                                /*
                                 Image("TrophyGold")
                                     .resizable()
                                     .scaledToFit()
                                     .frame(width: ScreenUtil.width * 0.12, height: ScreenUtil.width * 0.19)
                                 
                                Image("MedalGold")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.1)
                                */
                            }
                            .padding(.leading, ScreenUtil.width * 0.085)
                            .padding(.trailing, ScreenUtil.width * 0.0665)
                            
                        }
                    
                }//END Scroll view for accolades
                .frame(width: ScreenUtil.width * 0.93)
                .cornerRadius(ScreenUtil.height * 0.02)
                .padding(.top, UIScreen.main.bounds.height * 0.008)
                
            } //end HStack for button switcher and scrollview
      
        } //end ZStack for banner image and scroll view
        
    } //end body
  
}

struct AccoladeBanner_Previews: PreviewProvider {
    static var previews: some View {
        AccoladeBanner()
    }
}
