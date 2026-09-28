//
//  LeaderboardBottom.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/13/23.
//

import SwiftUI

struct LeaderboardBottom: View {
    
    @State public var placeValue: Int
    
    init(placeValue: Int) {
        self.placeValue = placeValue
    }
    
    var body: some View {
        
        switch placeValue {
            
        case 1:
                  
            Image("BottomGold3")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width)
                .padding(.bottom, 5)
                
        case 2:
            
            Image("BottomSilver3")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width)
                .padding(.bottom, 5)
            
        case 3:
            
            Image("BottomBronze3")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width)
            
        default:
            
            Image("Bottom4-10-3")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width)
            
            
            
        } //end switch
            
    } //end body
    
    
}
struct LeaderboardBottom_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardBottom(placeValue: 1)
    }
}
