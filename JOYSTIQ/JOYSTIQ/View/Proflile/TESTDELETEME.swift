//
//  WardrobeView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/10/23.
//

import SwiftUI

struct WardrobeView: View {
    
    @Binding var hideNavBar: Bool
    
    //@Binding var sceneView: SceneKitView
    @State private var sceneKitView = SceneKitView(named: "skintone6")
    
 
    var body: some View {
        
        VStack (spacing: 0) { //Main VStack for sceneKitView and wardrobe controls
            
            
            
            Divider()
                .frame(height: 5)
                .background(Color.gray)
                   
            sceneKitView
                .frame(height: UIScreen.main.bounds.height * 0.5)
            
            
            Divider()
                .frame(height: 5)
                .background(Color.gray)

            
            
            
            NavigationView {
                
                    
                Grid(horizontalSpacing: 40, verticalSpacing: 30) { //start grid for cosmetic customizations menu
                    
                    GridRow { //start gridrow1
                        
                        NavigationLink(destination: ShirtColorSwitcherView(sceneView: $sceneKitView)) { //start navlink
                            
                            ZStack { //for torso button

                                Image(systemName: "square")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(Color("LightGray"))
                                
                                
                                Image(systemName: "tshirt.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color("LightGray"))
                                
                            } //end zstack for torso button
                            
                            
                                                    
                        } //end navLink

                        
                        ZStack {

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Image(systemName: "questionmark")
                                .resizable()
                                .frame(width: 25, height: 40)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                        
                        
                        ZStack {

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Image(systemName: "questionmark")
                                .resizable()
                                .frame(width: 25, height: 40)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                        
                        
                        
                    } //end gridrow1
                    
                    GridRow { //start gridrow2
                        
                        ZStack {

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Image(systemName: "questionmark")
                                .resizable()
                                .frame(width: 25, height: 40)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                        
                        ZStack {

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Image(systemName: "questionmark")
                                .resizable()
                                .frame(width: 25, height: 40)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                        
                        ZStack {

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Image(systemName: "questionmark")
                                .resizable()
                                .frame(width: 25, height: 40)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                        
                        
                    } //end gridrow2
                    
                    
                    Divider()
                        .frame(width: UIScreen.main.bounds.width * 0.7, height: 1)
                        .background(Color.gray)
                    
                    
                    HStack(spacing: 20) { //for save and cancel buttons
                        
                        //Cancel button
                        Button(action: {
                            
                            
                        }, label: {
                            
                            Text("Cancel")
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width * 0.25, height: 45)
                                .background(LinearGradient(
                                    gradient: Gradient(colors: [Color.red, Color(red: 0.9, green: 0.3, blue: 0)]),
                                                startPoint: .topTrailing,
                                                endPoint: .bottomLeading
                                            ))
                                .cornerRadius(30)
                        })
                        .contentShape(Rectangle())
                    
                        

                        
                        //Confirm code button
                        Button(action: {
                            
                            //self.image = sceneKitView.takeSnapshot()
                            
                        }, label: {
                            
                            Text("Save")
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width * 0.35, height: 45)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]),
                                        startPoint: .topTrailing,
                                        endPoint: .bottomLeading
                                    )
                                )
                                .cornerRadius(30)
                        })
                        .contentShape(Rectangle())
                        
          
                        
                    } //end HStack for save and cancel buttons
                    
                    
                } //end grid for cosmetic customizations menu/
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
                .background(Color.black)
                     
    
            } //end navigation view
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
            .accentColor(Color.white.opacity(0.8))
            
        
            
        } //end Main VStack for scenekitview and wardrobe controls
        .edgesIgnoringSafeArea(.all)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color("GradientDark"))
        .onAppear {
            hideNavBar = true
        }
        
    }
    
}

struct ShirtColorSwitcherView: View {
    
    
    
    @Binding var sceneView: SceneKitView
    
    var body: some View {
        
        Grid(horizontalSpacing: 40) { //start grid for cosmetic customizations menu
            
            GridRow { //start gridrow1
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color("LightGray"))
                    
                    
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color("LightGray"))
                    
                }
                .onTapGesture {
                    sceneView.removeNode(named: "Shirt")

                }
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color("LightGray"))
                        .zIndex(1)
                    
                    
                    Color(.red)
                        .frame(width: 70, height: 70)
                        .zIndex(0)
                    
                }
                .onTapGesture {
                    sceneView.addNode(named: "RedDefaultShirt")
                }
                
                
                ZStack {

                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color("LightGray"))
                        .zIndex(1)
                    
                    
                    Color("GradientDark2")
                        .frame(width: 70, height: 70)
                        .zIndex(0)
                    
                }
                .onTapGesture {
                    sceneView.addNode(named: "DefaultShirt")
                }
                
                
                
            } //end gridrow1
            
        } //end grid
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .background(.black)
        
        
    } //end body
    
    
}


struct WardrobeView_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeView(hideNavBar: .constant(true))
    }
}

