//
//  WardrobeView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/14/23.
//


import SwiftUI
import SceneKit

struct WardrobeView: View {
    
    @Binding var hideNavBar: Bool

    @Binding var avatarSnapshot: UIImage?
    @Binding var enviroInt: Int
    
    @State private var sceneKitView = SceneKitView(named: "CamTest6", skinColor: "#ffdab0")



    var body: some View {
        
        VStack (spacing: 0) { //Main VStack for sceneKitView and wardrobe controls
            
            Spacer()
            
            Image("createyouravatar")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.6, height: 30)
                .padding(.bottom, 10)
            
            Divider()
                .frame(height: 2)
                .background(Color.green)
                   
            ZStack { //for scene and backround environment image
                
                sceneKitView
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
                    .zIndex(1)
                
                Image("wardrobeTest3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
                    .zIndex(0)
                    
                
            }//end ZStack for scene and backround environment image
            
            
            
            
            
            Divider()
                .frame(height: 4)
                .background(Color.black)
            
            
            NavigationView {
                
                    
                Grid(horizontalSpacing: 20, verticalSpacing: 20) { //start grid for cosmetic customizations menu
                    
                    GridRow { //start gridrow1
                        
                        NavigationLink(destination: SkinToneSwitcherView(sceneKitView: $sceneKitView)) { //start navlink
                            
                            ZStack { //for torso button

                                Image(systemName: "square")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color("LightGray"))
                                
                                
                                Image(systemName: "figure.stand")
                                    .resizable()
                                    .frame(width: 15, height: 30)
                                    .foregroundColor(Color("LightGray"))
                                
                            } //end zstack for torso button
                            
                        } //end navLink
                        
                        NavigationLink(destination: HairSwitcherView(sceneKitView: $sceneKitView)) { //start hair navlink
                            
                            ZStack {
                                
                                Image(systemName: "square")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color("LightGray"))
                                
                                Image("hairicon")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color("LightGray"))
                                
                            }
                        }
                        
                        
                                            

                        
                        NavigationLink(destination: ShirtSwitcherView(sceneKitView: $sceneKitView)) { //start navlink
                            
                            ZStack { //for torso button

                                Image(systemName: "square")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color("LightGray"))
                                
                                
                                Image(systemName: "tshirt.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color("LightGray"))
                                
                            } //end zstack for torso button
                            
                            
                                                    
                       } //end navLink
                        
                        
                        
                        
                        
                        
                        
                        
                    } //end gridrow1
                    
                    GridRow { //start gridrow2
                        
                        NavigationLink(destination: PantSwitcherView(sceneKitView: $sceneKitView)) {
                            
                            ZStack {
                                
                                Image(systemName: "square")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color("LightGray"))
                                
                                
                                Image("shorts")
                                    .resizable()
                                    .frame(width: 25, height: 30)
                                    .foregroundColor(Color("LightGray"))
                                
                            }
                            
                        }
                        
                        NavigationLink(destination: ShoeSwitcherView(sceneKitView: $sceneKitView)) { //start navlink
                            
                            ZStack { //for torso button

                                Image(systemName: "square")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color("LightGray"))
                                
                                
                                Image(systemName: "shoeprints.fill")
                                    .resizable()
                                    .frame(width: 25, height: 30)
                                    .foregroundColor(Color("LightGray"))
                                
                            } //end zstack for torso button
                            
                        } //end navLink
                        
                        
                        NavigationLink(destination: EnvironmentSwitcherView(enviroInt: $enviroInt)) {
                            
                            ZStack {
                                
                                Image(systemName: "square")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color("LightGray"))
                                
                                
                                Image(systemName: "photo.on.rectangle.angled")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color("LightGray"))
                                
                            }
                        }
                        
                    } //end gridrow2
                    
                    
                    Divider()
                        .frame(width: UIScreen.main.bounds.width * 0.7, height: 1)
                        .background(Color.gray)
                    
                    
                    HStack(spacing: 20) { //for save and cancel buttons
                        
                        /*
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
                    */
                        

                        
                        //Save button
                        Button(action: {
                            
                            avatarSnapshot = sceneKitView.takeTheSnapshot()
               
                            
                        }, label: {
                            
                            Text("Save")
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width * 0.5, height: 45)
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
                .background(Color("GradientDark"))
                     
    
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






struct WardrobeView_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeView(hideNavBar: .constant(true), avatarSnapshot: .constant(UIImage(systemName: "person.circle")!), enviroInt: .constant(1))
        //profileImage: .constant(UIImage(systemName: "person.circle")!)
    }
}

