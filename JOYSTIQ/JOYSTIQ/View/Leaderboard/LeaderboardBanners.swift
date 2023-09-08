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
            
            Image("newGold")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .padding(.top, 5)
    
            
        case 2:
            
            Image("newSilver")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.95)
                //.padding(.top, 7)
            
        case 3:
            
            Image("newBronze")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.95)
                //.padding(.top, 7)
            
            
        case 4:
            
            Image("4bannerNew")
                .resizable()
                .scaledToFit()
                .frame(height: 60)
                //.padding(.top, 7)
            
            
        case 5:
            
            Image("5bannerNew")
                .resizable()
                .scaledToFit()
                .frame(height: 60)
                //.padding(.top, 7)
            
        case 6:
            
            Image("6bannerNew")
                .resizable()
                .scaledToFit()
                .frame(height: 78)
                //.padding(.top, 7)
            
        case 7:
            
            Image("7bannerNew")
                .resizable()
                .scaledToFit()
                .frame(height: 78)
                //.padding(.top, 7)
            
        case 8:
            
            Image("8bannerNew")
                .resizable()
                .scaledToFit()
                .frame(height: 78)
                //.padding(.top, 7)
            
        case 9:
            
            Image("9bannerNew")
                .resizable()
                .scaledToFit()
                .frame(height: 78)
                //.padding(.top, 7)
            
        case 10:
            
            Image("10bannerNew")
                .resizable()
                .scaledToFit()
                .frame(height: 78)
                //.padding(.top, 7)
            
        default:
            
            ZStack {
                
                Image(systemName: "1.circle")
                    .font(.system(size: 40))
                
                
            }
            .frame(width: UIScreen.main.bounds.width-80, height: 48)
            .cornerRadius(20)
            .background(.yellow)
            
        } //end switch
            
    } //end body
    
    
}

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

struct LeaderboardBanners_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardBanners(placeValue: 1)
    }
}
