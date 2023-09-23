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
        
        ScrollView(.horizontal, showsIndicators: false) {
            
                    HStack(spacing: 20) { // Adjust the spacing between items as needed
                        
                        
                        
                        ZStack {

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Text("Anh hair")
                                .font(.system(size: 8))
                                .frame(width: 60, height: 25)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                        .onTapGesture {
                            sceneKitView.addNode(named: "AvatarNodes/Male/Hair/AnhHair1")

                        }
                        
                        
                        
                        
                        ZStack {

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Text("Elena hair")
                                .font(.system(size: 8))
                                .frame(width: 60, height: 25)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                        .onTapGesture {
                            sceneKitView.addNode(named: "AvatarNodes/Male/Hair/elenahair")

                        }
                        
                        
                        ZStack {

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Text("Mohawk")
                                .font(.system(size: 8))
                                .frame(width: 60, height: 25)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                        .onTapGesture {
                            sceneKitView.addNode(named: "AvatarNodes/Male/Hair/Mohwawk")
                        }
                        
                        
                        
                        ZStack {

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Text("Afro")
                                .font(.system(size: 8))
                                .frame(width: 60, height: 25)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                        .onTapGesture {
                            sceneKitView.addNode(named: "AvatarNodes/Male/Hair/afro")
                        }
                        
                        
                        
                        
                        ZStack {

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Text("Long Hair")
                                .font(.system(size: 8))
                                .frame(width: 60, height: 25)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                        .onTapGesture {
                            sceneKitView.addNode(named: "AvatarNodes/Male/Hair/longhair")

                        }
                        
                        
                        
                        ZStack {

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Text("Short Hair")
                                .font(.system(size: 8))
                                .frame(width: 60, height: 25)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                        .onTapGesture {
                            sceneKitView.addNode(named: "AvatarNodes/Male/Hair/shorthair")

                        }
                        
                        
                        
                        
                        ZStack {

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Text("Buzz cut")
                                .font(.system(size: 8))
                                .frame(width: 60, height: 25)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                        .onTapGesture {
                            sceneKitView.addNode(named: "AvatarNodes/Male/Hair/buzzcut")

                        }
                        
                        ZStack {

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Text("curly")
                                .font(.system(size: 8))
                                .frame(width: 60, height: 25)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                        .onTapGesture {
                            sceneKitView.addNode(named: "AvatarNodes/Male/Hair/curly")

                        }
                        
                        ZStack {

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Text("curly2")
                                .font(.system(size: 8))
                                .frame(width: 60, height: 25)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                        .onTapGesture {
                            sceneKitView.addNode(named: "AvatarNodes/Male/Hair/curly2")

                        }
                        
                        ZStack {

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Text("curly3")
                                .font(.system(size: 8))
                                .frame(width: 60, height: 25)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                        .onTapGesture {
                            sceneKitView.addNode(named: "AvatarNodes/Male/Hair/curly3")

                        }
                        
                        /*
                        ZStack {

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Text("flattop")
                                .font(.system(size: 8))
                                .frame(width: 60, height: 25)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                        .onTapGesture {
                            sceneKitView.addNode(named: "AvatarNodes/Male/Hair/flattop")

                        }
                         */
                        
                    } //end HStack
                    
                } //end ScrollView
        
        
        
        /*
        
        Grid(horizontalSpacing: 20, verticalSpacing: 30) { //start grid for cosmetic customizations menu
            
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
                    sceneKitView.addNode(named: "AvatarNodes/Male/Hair/AnhHair1")

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
                    sceneKitView.addNode(named: "AvatarNodes/Male/Hair/elenahair")

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
                    sceneKitView.addNode(named: "AvatarNodes/Male/Hair/Mohwawk")
                }
                
                
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color("LightGray"))
                    
                    
                    Text("Afro")
                        .font(.system(size: 12))
                        .frame(width: 80, height: 25)
                        .foregroundColor(Color("LightGray"))
                    
                }
                .onTapGesture {
                    sceneKitView.addNode(named: "AvatarNodes/Male/Hair/afro")
                }
                
                
          
                
            } //end gridrow1
            
            
            
            
            
            GridRow { //start gridrow2
                
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color("LightGray"))
                    
                    
                    Text("Long Hair")
                        .font(.system(size: 12))
                        .frame(width: 80, height: 25)
                        .foregroundColor(Color("LightGray"))
                    
                }
                .onTapGesture {
                    sceneKitView.addNode(named: "AvatarNodes/Male/Hair/longhair")

                }
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color("LightGray"))
                    
                    
                    Text("Short Hair")
                        .font(.system(size: 12))
                        .frame(width: 80, height: 25)
                        .foregroundColor(Color("LightGray"))
                    
                }
                .onTapGesture {
                    sceneKitView.addNode(named: "AvatarNodes/Male/Hair/shorthair")

                }
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color("LightGray"))
                    
                    
                    Text("Buzz cut")
                        .font(.system(size: 12))
                        .frame(width: 80, height: 25)
                        .foregroundColor(Color("LightGray"))
                    
                }
                .onTapGesture {
                    sceneKitView.addNode(named: "AvatarNodes/Male/Hair/buzzcut")

                }
                
                
                
                
                
                
                
                
                
            } //end gridrow2
            
        } //end grid
        .padding(.bottom, 20)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .background(.black)
        */
        
    } //end body
    
    
}

struct HairContentView: View {
    
    
    @State private var sceneKitView = SceneKitView(named: "CamTest6", skinColor: "#ffdab0")
    
    var body: some View {
        
        HairSwitcherView(sceneKitView: $sceneKitView)
        
    }
    
}



struct HairSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        HairContentView()
    }
}
