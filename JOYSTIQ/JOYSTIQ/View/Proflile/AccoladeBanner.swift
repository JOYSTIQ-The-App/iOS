//
//  AccoladeBanner.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 4/24/23.
//

import SwiftUI

struct AccoladeBanner: View {
    
    @State private var mode = "game_and_accolade"
    
    let icons = ["Logo1", "TrophyGold", "Logo5", "MedalGold", "Logo4", "MedalSilver", "Logo3","Logo7", "Logo6"]
    
    let accoladeArr = ["MedalGold"]
    
    let gamesArr = ["Logo5", "Logo1", "Logo7", "Logo6", "Logo2", "Logo4", "Logo3"]
    
    
    var body: some View {
        
        ZStack { //start Zstack for banner image and scroll view
            
            
            HStack{ //Hstack to space banner image to right side
                
                Spacer()
                
                
                Image("FIN4")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.85, height: 100)
                
            } //end Hstack for space and image
            
            
            
            HStack { //Hstack and spacer to push scrollview to right
                
                
                
                Button(action: {
                    
                    switch self.mode {
                                case "game_and_accolade":
                                    self.mode = "game_only"
                                case "game_only":
                                    self.mode = "accolade_only"
                                case "accolade_only":
                                    self.mode = "game_and_accolade"
                                default:
                                    break
                                }
                    
                }, label: {
                    
                    switch mode {
                        
                    case "game_and_accolade":
                        
                        Image(systemName: "arrow.left.arrow.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    
                    case "accolade_only":
                        
                        //display accolades only button
                        Image(systemName: "medal.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                        
                    case "game_only":
                        
                        Image(systemName: "gamecontroller.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
    
                    
                    default:
                        
                        Image(systemName: "arrow.left.arrow.right.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        
                    } // END Switch determining button type
                    
                }) //END Button for accolade filter
                .background(
                    Circle()
                    .fill(.green)
                    .frame(width: 50, height: 50)
                    
                )
                .padding(.leading, 20)
                
                
                
                
                
                Spacer()
                
                
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 5) { //Main HStack, filter + games + accolades
                        
                    
                        //print each game + accolade
                        switch mode{
                          
                        case "game_and_accoldae":
                            
                            HStack(spacing: 20) {
                                Image("Logo1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(15)
                                    .padding()
                                
                                Image("TrophyGold")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 80)
                                
                                Image("Logo5")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(15)
                                    .padding()
                                
                                Image("MedalBronze")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                
                                Image("Logo4")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(15)
                                    .padding()
                                
                                Image("TrophyBronze")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 80)
                                
                            }
                            .padding(.horizontal, 30)
                            
                            
                        case "game_only":
                            
                            ForEach(gamesArr, id: \.self) { icon in
                                
                                Image(icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(15)
                                    .padding()
                            }
                            
                        
                        case "accolade_only":
                               
                            HStack(spacing: 26) {
                                Image("TrophyGold")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 80)
                                
                                Image("MedalGold")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                
                                Image("TrophySilver")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 80)
                                
                                Image("MedalSilver")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                
                                Image("TrophyBronze")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 80)
                                
                                Image("MedalBronze")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                
                            }
                            .padding(.horizontal, 20)
                            
                        
                        default:
                            
                            HStack(spacing: 20) {
                                Image("Logo1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(15)
                                    .padding()
                                
                                Image("TrophyGold")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 80)
                                
                                Image("Logo5")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(15)
                                    .padding()
                                
                                Image("MedalBronze")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                
                                Image("Logo4")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(15)
                                    .padding()
                                
                                Image("TrophyBronze")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 80)
                                
                            }
                            .padding(.horizontal, 0)
                            
                        }
                        
                       
                        
                        /* EXPAND BUTTON
                         
                         
                        //chevron button to dropdown accolade banner
                        Button(action: {
                            //dropdown accolade banner
                            
                        }, label: {
                            
                            Image(systemName: "chevron.down.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                
                        })
                        .frame(width: 45, height: 45)
                        .foregroundColor(.blue)
                        .padding(.leading, 10)
                        .padding(.trailing, 20)
                        
                        */
                        
                        
                        
                        
                    } //END HStack
                    
                    .padding(.top, 20)
                    
                }//END Scroll view for accolades
                //.padding(.leading, 50)
                .frame(width: UIScreen.main.bounds.width * 0.76, height: 120)
                .foregroundColor(.white)
                
            }
            
            
            
           
            
        }
        
        
        
        
        
        
        
        
        
    }
}


struct AccoladeBanner_Previews: PreviewProvider {
    static var previews: some View {
        AccoladeBanner()
    }
}
