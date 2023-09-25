//
//  EnvironmentSwitcherView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/20/23.
//

import SwiftUI

struct EnvironmentSwitcherView: View {
    
    @Binding var enviroInt: Int
    
    var body: some View {
        
        
        
        Grid(horizontalSpacing: 40) { //start grid for cosmetic customizations menu
            
            GridRow { //start gridrow1
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 85, height: 65)
                        .foregroundColor(enviroInt == 0 ? Color.green : Color("LightGray"))
                        .zIndex(1)
                    
                    Image("defaultEnv")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 65, height: 60)
                        .zIndex(0)
                
                    
                }
                .onTapGesture {
                    enviroInt = 0
                }
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 90, height: 65)
                        .foregroundColor(enviroInt == 1 ? Color.green : Color("LightGray"))
                        .zIndex(1)
                    
                    Image("bedroomEnv")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .zIndex(0)
                
                    
                }
                .onTapGesture {
                    enviroInt = 1
                }
                
                
                
                
            } //end gridrow1
            .padding(.bottom, 40)
            
        } //end grid
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .background(Color("GradientDark"))
        
        
    } //end body
    
}

struct EnvironmentSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        EnvironmentSwitcherView(enviroInt: .constant(0))
    }
}
