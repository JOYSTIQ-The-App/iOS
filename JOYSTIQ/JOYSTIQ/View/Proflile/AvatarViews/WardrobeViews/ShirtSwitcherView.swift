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
    
    let torsoColorOptions = ["Default", "Black", "Brown", "Blonde", "Red", "White"]
    
    @State private var currentStyle = "nil"
    
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
                    
                    if selectedTorsoIndex >= 1 {
                        selectedTorsoIndex -= 1
                    }
                    
                    switch selectedTorsoIndex {
                        
                    case 0: //from tanktop to shirt
                        
                        sceneKitView.replaceNode(named: "Tanktop", named: "AvatarNodes/Male/Torso/MDefaultShirt")
                        
                    case 1: //replace sweater with tank tpp
                    
                        sceneKitView.replaceNode(named: "sweater_black", named: "AvatarNodes/Male/Torso/MTanktop")
                     
                        
                    case 2: //replace tank top with sweater
                       
                        print("Do nothing")
                    

                    default:
                        
                        print("Do nothing")
                        
                        
                    } //end switch
                    
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
                    
                
                
                // Right arrow button for hairstyle
                Button(">") {
        
                    
                    selectedTorsoColorIndex = 0
                    
                    if selectedTorsoIndex <= 1 { //do not exceed array length
                        
                        selectedTorsoIndex += 1
                        
                        
                        switch selectedTorsoIndex {
                            
                        case 0:
                            
                         print("Do nothing") //won't ever happen
                            
                        case 1: //replace shirt with tank top
                        
                            sceneKitView.replaceNode(named: "Shirt", named: "AvatarNodes/Male/Torso/MTanktop")
                         
                            
                        case 2: //replace tank top with sweater
                           
                            sceneKitView.replaceNode(named: "Tanktop", named: "AvatarNodes/Male/Torso/blacksweater")
                        
    
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
        
            
            /*
            HStack {
                
                Image(systemName: "paintpalette.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("LightGray"))
                    .padding(.trailing, 13)
                
                
                Spacer()
                
                
                // Left arrow button for hair color
                Button("<") {
                    
                    //selectedHairColorIndex = (selectedHairColorIndex - 1 + hairColorOptions.count) % hairColorOptions.count
                    
                    
                    if selectedHairColorIndex >= 1 {
                        selectedHairColorIndex -= 1
                    }
                    
                    
                    switch selectedHairColorIndex {
                        
                    case 0:
                        print("do nothing")
                    
                    case 1: //black color
                        
                        sceneKitView.changeHairColor(named: currentStyle, named: "#121212")
                        sceneKitView.changeEyebrow(named: "#121212")
                        
                    case 2: //brown color
                        
                        sceneKitView.changeHairColor(named: currentStyle, named: "#7a5820")
                        sceneKitView.changeEyebrow(named: "#7a5820")
                        
                    case 3: //blonde color
                        
                        sceneKitView.changeHairColor(named: currentStyle, named: "#faf0be")
                        sceneKitView.changeEyebrow(named: "#faf0be")
                        
                    case 4: //red color
                        
                        sceneKitView.changeHairColor(named: currentStyle, named: "#943400")
                        sceneKitView.changeEyebrow(named: "#943400")
                        
                    default:
                        print("do nothing")
                        
                        
      
                    }//end switch
                    
                    
                }
                .foregroundColor(selectedHairColorIndex == 0 ? .gray : .green)
                .padding(.all, 2)
                .font(.system(size: 28))
                .buttonStyle(NeumorphicButtonStyle())
                
                Text("\(hairColorOptions[selectedHairColorIndex])")
                    .font(.system(size: 18))
                    .foregroundColor(Color("LightGray"))
                    .frame(width: 200, height: 40)
                    .background(Color("GradientLight"))
                    .cornerRadius(5)
                    .padding(.horizontal, 10)
                    
                
                // Right arrow button for hair color
                // hairColorOptions = ["Default", "Black", "Brown", "Blonde", "Red", "White"]
                Button(">") {
                    
                    //selectedHairColorIndex = (selectedHairColorIndex + 1) % hairColorOptions.count
                    
                    if selectedHairColorIndex <= 4 {
                        selectedHairColorIndex += 1
                        
                        switch selectedHairColorIndex {
                            
                        case 0:
                            print("do nothing")
                        
                        case 1: //black color
                            
                            sceneKitView.changeHairColor(named: currentStyle, named: "#121212")
                            sceneKitView.changeEyebrow(named: "#121212")
                            
                        case 2: //brown color
                            
                            sceneKitView.changeHairColor(named: currentStyle, named: "#7a5820")
                            sceneKitView.changeEyebrow(named: "#7a5820")
                            
                        case 3: //blonde color
                            
                            sceneKitView.changeHairColor(named: currentStyle, named: "#faf0be")
                            sceneKitView.changeEyebrow(named: "#faf0be")
                            
                        case 4: //red color
                            
                            sceneKitView.changeHairColor(named: currentStyle, named: "#943400")
                            sceneKitView.changeEyebrow(named: "#943400")
                            
                        case 5: //white color
                            
                            sceneKitView.changeHairColor(named: currentStyle, named: "#ffffff")
                            sceneKitView.changeEyebrow(named: "#ffffff")
                            
                        default:
                            print("do nothing")
                            
                            
                        } //end switch
                        
                    } //end if
                    
    
                    
                }
                .foregroundColor(selectedHairColorIndex == 5 ? .gray : .green)
                .padding(.all, 2)
                .font(.system(size: 28))
                .buttonStyle(NeumorphicButtonStyle())
                
                
                Spacer()
                
                
            }//end HStack for color selector
            */
            
            
            
            
            
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
