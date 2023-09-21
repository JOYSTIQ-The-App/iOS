//
//  HairSwitcherView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/21/23.
//

import SwiftUI

struct HairSwitcherView: View {
    
    @Binding var sceneKitView: SceneKitView
    
    var body: some View {
        
        Grid(horizontalSpacing: 40) { //start grid for cosmetic customizations menu
            
            GridRow { //start gridrow1
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color("LightGray"))
                    
                    
                    Text("Anh hair")
                        .font(.system(size: 12))
                        .frame(width: 80, height: 25)
                        .foregroundColor(Color("LightGray"))
                    
                }
                .onTapGesture {
                    sceneKitView.addaNode(named: "AvatarNodes/Male/Hair/AnhHair1")

                }
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color("LightGray"))
                    
                    
                    Text("Elena hair")
                        .font(.system(size: 12))
                        .frame(width: 80, height: 25)
                        .foregroundColor(Color("LightGray"))
                    
                }
                .onTapGesture {
                    sceneKitView.addaNode(named: "AvatarNodes/Male/Hair/elenahair")

                }
                
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color("LightGray"))
                    
                    
                    Text("Mohawk")
                        .font(.system(size: 12))
                        .frame(width: 80, height: 25)
                        .foregroundColor(Color("LightGray"))
                    
                }
                .onTapGesture {
                    sceneKitView.addaNode(named: "AvatarNodes/Male/Hair/Mohwawk")

                }
                
                
                
            } //end gridrow1
            .padding(.bottom, 40)
            
        } //end grid
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .background(.black)
        
        
    } //end body
    
    
}

struct HairContentView: View {
    
    
    @State private var sceneKitView = SceneKitView(named: "CamTest6")
    
    var body: some View {
        
        HairSwitcherView(sceneKitView: $sceneKitView)
        
    }
    
}



struct HairSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        HairContentView()
    }
}
