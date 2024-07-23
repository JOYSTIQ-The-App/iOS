//
//  AccoladeBanner.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 4/24/23.
//

import SwiftUI

struct AccoladeBanner: View {
    
    @State private var mode = "game_only" //game only as default, other options are accolade_only and game_and_accolade
    @State private var gameMode = true
    
//    let icons = ["Logo1", "TrophyGold", "Logo5", "MedalGold", "Logo4", "MedalSilver", "Logo3","Logo7", "Logo6"]
    
//    let accoladeArr = ["MedalGold"]
    
//    var gamesArr = []
    

    var body: some View {
        
        ZStack { //start Zstack for banner image and scroll view
            
            
            HStack{ //Hstack to space banner image to right side
                
                Spacer()
                
                
                Image("AccBannerAtt2")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.07)
                    .shadow(color: Color.black, radius: 3, x: 4, y: 4)
                
            } //end Hstack for space and image
            
            
            
            HStack { //Hstack and spacer to push scrollview to right
                
                
                
                Button(action: {
                    
                    gameMode.toggle()
                    
                }, label: {
                    
                    Image(systemName: gameMode ? "gamecontroller.fill" : "medal.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.06, height: UIScreen.main.bounds.width * 0.06)
                        .foregroundColor(Color("LightGray"))
                    
                }) //END Button for accolade filter
               
                .padding(.leading, 10)
                .buttonStyle(NeumorphicRectangleButtonStyle())
                
                
                
                
                Spacer()
                
                
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 0) { // games + accolades
                        

                        //print each game + accolade
                        switch gameMode{
                          
                  
                            
                        case true:
                            
                            //Spacer, create some leading padding without modifying scrollview width
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width * 0.07, height: UIScreen.main.bounds.width * 0.09)
                                .foregroundColor(Color.clear)
                            
//                            ForEach(Array(gamesArr.enumerated()), id: \.element) { (index, icon) in
//                                Image(icon)
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: UIScreen.main.bounds.width * 0.085, height: UIScreen.main.bounds.width * 0.085)
//                                    .cornerRadius(10)
//                                    .padding(.top, UIScreen.main.bounds.width * 0.01)
//                                    .padding(.trailing, index < gamesArr.count - 1 ? UIScreen.main.bounds.width * 0.103 : UIScreen.main.bounds.width * 0.016)
//                            }
                            
    
                        
                        case false:
                               
                            HStack(spacing: UIScreen.main.bounds.width * 0.066) {
                                
                                Image("TrophyGold")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.13)
                                
                                Image("MedalAlpha")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.1)
                                
                                Image("MedalBeta")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.1)
                                
                                Image("MedalGold")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.1)
                                
                                Image("MedalGold")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.1)
                                
                                Image("TrophySilver")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.13)
                                
                                Image("MedalSilver")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.1)
                                
                                Image("TrophyBronze")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.13)
                                
                                Image("MedalBronze")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.1)
                                
                            }
                            .padding(.leading, UIScreen.main.bounds.width * 0.055)
                            
                            
                        }
                        
                        
                    } //END HStack
                    .padding(.trailing, UIScreen.main.bounds.width * 0.048)
                    
                }//END Scroll view for accolades
                //.padding(.leading, UIScreen.main.bounds.width * 0.068)
                .frame(width: UIScreen.main.bounds.width * 0.78)
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
