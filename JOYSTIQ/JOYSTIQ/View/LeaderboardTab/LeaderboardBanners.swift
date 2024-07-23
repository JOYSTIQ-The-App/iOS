//
//  LeaderboardBanners.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 7/6/23.
//

import SwiftUI

struct LeaderboardBanners: View {
    
    @State public var placeValue: Int
    
    init(placeValue: Int) {
        self.placeValue = placeValue
    }
    
    var body: some View {
        
        switch placeValue {
            
        case 1:
            
            Image("GoldBanner")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .padding(.top, 5)
                .shadow(color: Color.black, radius: 5, x: 2, y: 2)
                .shadow(color: Color.yellow.opacity(0.5), radius: 5, x: -2, y: -2)
    
            
        case 2:
            
            Image("SilverBanner")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .shadow(color: Color.black, radius: 5, x: 2, y: 2)
                .shadow(color: Color.white.opacity(0.5), radius: 5, x: -2, y: -2)
            
        case 3:
            
            Image("BronzeBanner")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .shadow(color: Color.black, radius: 5, x: 2, y: 2)
                .shadow(color: Color.brown, radius: 5, x: -2, y: -2)
            
            
        case 4:
            
            Image("4banner")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
                .shadow(color: Color.black, radius: 2, x: 2, y: 2)
                .shadow(color: Color.white.opacity(0.5), radius: 2, x: -2, y: -2)
            
            
        case 5:
            
            Image("5banner")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
                .shadow(color: Color.black, radius: 2, x: 2, y: 2)
                .shadow(color: Color.white.opacity(0.5), radius: 2, x: -2, y: -2)
            
        case 6:
            
            Image("6banner")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
                .shadow(color: Color.black, radius: 2, x: 2, y: 2)
                .shadow(color: Color.white.opacity(0.5), radius: 2, x: -2, y: -2)
            
        case 7:
            
            Image("7banner")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
                .shadow(color: Color.black, radius: 2, x: 2, y: 2)
                .shadow(color: Color.white.opacity(0.5), radius: 2, x: -2, y: -2)
            
        case 8:
            
            Image("8banner")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
                .shadow(color: Color.black, radius: 2, x: 2, y: 2)
                .shadow(color: Color.white.opacity(0.5), radius: 2, x: -2, y: -2)
            
        case 9:
            
            Image("9banner")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
                .shadow(color: Color.black, radius: 2, x: 2, y: 2)
                .shadow(color: Color.white.opacity(0.5), radius: 2, x: -2, y: -2)
            
        case 10:
            
            Image("10banner")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
                .shadow(color: Color.black, radius: 2, x: 2, y: 2)
                .shadow(color: Color.white.opacity(0.5), radius: 2, x: -2, y: -2)
            
        default:
            
            Image("GoldBanner")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .padding(.top, 5)
                .shadow(color: Color.black, radius: 2, x: 2, y: 2)
                .shadow(color: Color.yellow.opacity(0.5), radius: 2, x: -2, y: -2)
            
        } //end switch
            
    } //end body
    
    
}


struct LeaderboardBanners_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardBanners(placeValue: 1)
    }
}
