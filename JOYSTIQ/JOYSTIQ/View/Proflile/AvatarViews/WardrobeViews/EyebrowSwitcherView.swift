//
//  EyebrowSwitcherView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/21/23.
//

import SwiftUI

struct EyebrowSwitcherView: View {
    
    @Binding var sceneKitView: SceneKitView
    
    var body: some View {
        
        Grid(horizontalSpacing: 40) { //start grid for cosmetic customizations menu
            
            GridRow { //start gridrow1
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color("LightGray"))
                        .zIndex(1)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color(UIColor(hexString: "#000000")!)) //black color
                        .zIndex(0)
                
                    
                }
                .onTapGesture {
                    sceneKitView.changeEyebrow(named: "#000000") //black
                }
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color("LightGray"))
                        .zIndex(1)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color(UIColor(hexString: "#5c3f06")!)) //brown color
                        .zIndex(0)
                
                    
                }
                .onTapGesture {
                    sceneKitView.changeEyebrow(named: "#5c3f06") //brown
                }
                
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color("LightGray"))
                        .zIndex(1)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color(UIColor(hexString: "#ffffff")!)) //white color
                        .zIndex(0)
                
                    
                }
                .onTapGesture {
                    sceneKitView.changeEyebrow(named: "#ffffff") //white
                }
                
                
                
            } //end gridrow1
            
        } //end grid
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .background(.black)
        
        
    } //end body
    
    
}

/*
struct EyebrowSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        EyebrowSwitcherView()
    }
}
*/
