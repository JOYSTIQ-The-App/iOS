//
//  ShirtSwitcherView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/21/23.
//

import SwiftUI

struct ShirtSwitcherView: View {
    
    @Binding var sceneKitView: SceneKitView
    
    // Define your hairstyle and hair color options as arrays
    let torsoOptions = ["Shirt 0", "Shirt 1", "Shirt 2"]
    
    let torsoColorOptions = ["Default", "Red", "Green", "Blue", "Black", "White"]
    
    @State private var shirtStyle = "Shirt"
    
    @State private var selectedTorsoIndex = 0
    @State private var selectedTorsoColorIndex = 0
    
    var body: some View {
        
        VStack {
            
            HStack (spacing: 5) {
                
                Image(systemName: "tshirt.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("LightGray"))
                 
                
                Spacer()
                
                // Left arrow button for hairstyle
                Button("<") {
                    
                    selectedTorsoColorIndex = 0
                    
                    if selectedTorsoIndex >= 1 && selectedTorsoIndex != 0 {
                        
                        selectedTorsoIndex -= 1
                        
                        switch selectedTorsoIndex {
                            
                        case 0: //from tanktop to shirt
                            
                            shirtStyle = "Shirt"
                            sceneKitView.replaceNode(named: "Tanktop", named: "AvatarNodes/Male/Torso/MDefaultShirt")
                            
                        case 1: //replace sweater with tank tpp
                        
                            shirtStyle = "Tanktop"
                            sceneKitView.replaceNode(named: "sweater_black", named: "AvatarNodes/Male/Torso/MTanktop")
                         
                            
                        case 2:
                           
                            print("Do nothing")
                        

                        default:
                            
                            print("Do nothing")
                            
                            
                        } //end switch
                    }
                    
                    
                    
                }
                .foregroundColor(selectedTorsoIndex == 0 ? .gray : .green)
                .padding(.all, 2)
                .font(.system(size: 28))
                .buttonStyle(NeumorphicButtonStyle())
                
                
                // Display the selected hairstyle and hair color
                Text("\(torsoOptions[selectedTorsoIndex])")
                    .font(.system(size: 18))
                    .foregroundColor(Color("LightGray"))
                    .frame(width: 200, height: 40)
                    .background(Color("GradientLight"))
                    .cornerRadius(5)
                    .padding(.horizontal, 10)
                    
                
                
                // Right arrow button for shirt selection
                Button(">") {
        
                    
                    selectedTorsoColorIndex = 0
                    
                    if selectedTorsoIndex <= 1 { //do not exceed array length
                        
                        selectedTorsoIndex += 1
                        
                        
                        switch selectedTorsoIndex {
                            
                        case 0:
                            
                         print("Do nothing") //won't ever happen
                            
                        case 1: //replace shirt with tank top
                        
                            sceneKitView.replaceNode(named: "Shirt", named: "AvatarNodes/Male/Torso/MTanktop")
                            shirtStyle = "Tanktop"
                         
                            
                        case 2: //replace tank top with sweater
                           
                            sceneKitView.replaceNode(named: "Tanktop", named: "AvatarNodes/Male/Torso/blacksweater")
                            shirtStyle = "sweater"
    
                        default:
                            
                            print("Do nothing")
                            
                            
                        } //end switch
                        
                        
                    } //end if
                    
                    
                    
                    
                    
                }
                .foregroundColor(selectedTorsoIndex == 2 ? .gray : .green)
                .padding(.all, 2)
                .font(.system(size: 28))
                .buttonStyle(NeumorphicButtonStyle())
                
                
                Spacer()
                
            } //end HStack for style selector
            .padding(.bottom, 10)
        
            
            
            
            
            
            
            if selectedTorsoIndex != 2 { //if prevent sweater color
                
                HStack { //for color selector
                    
                    Image(systemName: "paintpalette.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("LightGray"))
                        .padding(.trailing, 13)
                    
                    
                    Spacer()
                    
                    
                    // Left arrow button for shirt color
                    Button("<") {
                        
                        
                        if selectedTorsoColorIndex >= 1 && selectedTorsoColorIndex != 0 {
                            
                            selectedTorsoColorIndex -= 1
                            
                            switch selectedTorsoColorIndex {
                                
                            case 0:
                                print("do nothing")
                            
                            case 1: //red
                                sceneKitView.changeShirtColor(named: shirtStyle, named: "#780000")
                                
                            case 2: //green
                                       
                                sceneKitView.changeShirtColor(named: shirtStyle, named: "#025901")
                                
                            case 3: //blue
                                       
                                sceneKitView.changeShirtColor(named: shirtStyle, named: "#044bbd")
                                
                            case 4: //black
                                       
                                sceneKitView.changeShirtColor(named: shirtStyle, named: "#212121")
                                
                                
                            default:
                                print("do nothing")
                                
                                
              
                            }//end switch
                            
                        }
                        
                        
                        
                        
                        
                    }
                    .foregroundColor(selectedTorsoColorIndex == 0 ? .gray : .green)
                    .padding(.all, 2)
                    .font(.system(size: 28))
                    .buttonStyle(NeumorphicButtonStyle())
                    
                    Text("\(torsoColorOptions[selectedTorsoColorIndex])")
                        .font(.system(size: 18))
                        .foregroundColor(Color("LightGray"))
                        .frame(width: 200, height: 40)
                        .background(Color("GradientLight"))
                        .cornerRadius(5)
                        .padding(.horizontal, 10)
                        
                    
                    // Right arrow button for shirt color
                    //["Default", "Red", "Green", "Blue", "Black", "White"]
                    Button(">") {
                        
                        
                        if selectedTorsoColorIndex <= 4 {
                 
                            selectedTorsoColorIndex += 1
                            
                            switch selectedTorsoColorIndex {
                                
                            case 0: //can't happen
                                print("do nothing")
                            
                            case 1: //red
                                sceneKitView.changeShirtColor(named: shirtStyle, named: "#780000")
                                
                            case 2: //green
                                       
                                sceneKitView.changeShirtColor(named: shirtStyle, named: "#025901")
                                
                            case 3: //blue
                                       
                                sceneKitView.changeShirtColor(named: shirtStyle, named: "#044bbd")
                                
                            case 4: //black
                                       
                                sceneKitView.changeShirtColor(named: shirtStyle, named: "#212121")
                                
                            case 5: //white
                                       
                                sceneKitView.changeShirtColor(named: shirtStyle, named: "#d7d7d9")
                                
                            default:
                                print("do nothing")
                                
                                
                            } //end switch
                            
                        } //end if
                        
        
                        
                    }
                    .foregroundColor(selectedTorsoColorIndex == 5 ? .gray : .green)
                    .padding(.all, 2)
                    .font(.system(size: 28))
                    .buttonStyle(NeumorphicButtonStyle())
                    
                    
                    Spacer()
                    
                    
                }//end HStack for color selector
                
                
                
            } //end if prevent sweater color
            
            
            
            
            
            
            
        } //end VStack for style and color selectors
        .padding(.bottom, 60)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .background(.black)
        
    } //end body
    
    
    
}


struct ShirtContentView: View {
    
    
    @State private var sceneKitView = SceneKitView(named: "CamTest6", skinColor: "#ffdab0")
    
    var body: some View {
        
        VStack {
            
            sceneKitView
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
            
            ShirtSwitcherView(sceneKitView: $sceneKitView)
            
        }
        
        
        
    }
    
}



struct ShirtSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        ShirtContentView()
    }
}
