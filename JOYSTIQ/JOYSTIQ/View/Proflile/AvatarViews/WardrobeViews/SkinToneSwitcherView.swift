//
//  SkinToneSwitcherView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/20/23.
//

import SwiftUI

struct SkinToneSwitcherView: View {
    
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
                        .foregroundColor(Color(UIColor(hexString: "#ffdab0")!)) //white color
                        .zIndex(0)
                
                    
                }
                .onTapGesture {
                    sceneKitView.changeSkinTone(named: "#ffdab0") //white
                }
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color("LightGray"))
                        .zIndex(1)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color(UIColor(hexString: "#faba73")!)) //tan color
                        .zIndex(0)
                
                    
                }
                .onTapGesture {
                    sceneKitView.changeSkinTone(named: "#faba73") //tan
                }
                
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color("LightGray"))
                        .zIndex(1)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color(UIColor(hexString: "#a37d5a")!)) //black color
                        .zIndex(0)
                
                    
                }
                .onTapGesture {
                    sceneKitView.changeSkinTone(named: "#a37d5a") //black
                }
                
                
                
            } //end gridrow1
            
        } //end grid
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .background(.black)
        
        
    } //end body
    
    
}

struct ContentView: View {
    
    
    @State private var sceneKitView = SceneKitView(named: "CamTest6")
    
    var body: some View {
        
        SkinToneSwitcherView(sceneKitView: $sceneKitView)
        
    }
    
}

struct SkinToneSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
