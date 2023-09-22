//
//  ShirtSwitcherView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/21/23.
//

import SwiftUI

struct ShirtSwitcherView: View {
    
    @Binding var sceneKitView: SceneKitView
    
    var body: some View {
        
        Grid(horizontalSpacing: 40) { //start grid for cosmetic customizations menu
            
            GridRow { //start gridrow1
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color("LightGray"))
                    
                    
                    Text("Default")
                        .font(.system(size: 12))
                        .frame(width: 80, height: 25)
                        .foregroundColor(Color("LightGray"))
                    
                }
                .onTapGesture {
                    sceneKitView.replaceNode(named: "Shirt", named: "AvatarNodes/Male/Torso/MDefaultShirt")

                }
                
                
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color("LightGray"))
                    
                    
                    Text("Tanktop")
                        .font(.system(size: 12))
                        .frame(width: 80, height: 25)
                        .foregroundColor(Color("LightGray"))
                    
                }
                .onTapGesture {
                    sceneKitView.replaceNode(named: "Shirt", named: "AvatarNodes/Male/Torso/MTanktop")

                }
                
                
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color("LightGray"))
                    
                    
                    Text("Sweater")
                        .font(.system(size: 12))
                        .frame(width: 80, height: 25)
                        .foregroundColor(Color("LightGray"))
                    
                }
                .onTapGesture {
                    sceneKitView.replaceNode(named: "Shirt", named: "AvatarNodes/Male/Torso/blacksweater")

                }
                
                
            } //end gridrow1
            .padding(.bottom, 40)
            
        } //end grid
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .background(.black)
        
        
    } //end body
    
    
}

struct ShirtContentView: View {
    
    
    @State private var sceneKitView = SceneKitView(named: "CamTest6")
    
    var body: some View {
        
        ShirtSwitcherView(sceneKitView: $sceneKitView)
        
    }
    
}



struct ShirtSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        ShirtContentView()
    }
}
