//
//  PantSwitcherView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/23/23.
//

import SwiftUI

struct PantSwitcherView: View {
    
    @Binding var sceneKitView: SceneKitView
    
    // Define your hairstyle and hair color options as arrays
    let pantsOptions = ["Pants 0", "Pants 1", "Pants 2"]
    
    //let pantsColorOptions = ["Blue", "Green", "Red", "Black", "White"]
    let pantsColorOptions = ["#044bbd", "#025901", "#780000", "#212121", "#d7d7d9"]
    
    
    @State private var pantsStyle = "shorts"
    
    @State private var selectedPantsIndex = 0
    @State private var selectedPantsColorIndex = 0
    
    var body: some View {
        
        VStack {
            
            Text("Select Pants")
                .font(.system(size: 18))
                .foregroundColor(Color("LightGray"))
            
            HStack (spacing: 5) {
                
                Spacer()
                
                // Left arrow button for pants selection
                Button("<") {
                    
                    selectedPantsColorIndex = 0
                    
                    if selectedPantsIndex >= 1 && selectedPantsIndex != 0 {
                        
                        selectedPantsIndex -= 1
                        
                        switch selectedPantsIndex {
                            
                        case 0: //from pants to shorts
                            
                            pantsStyle = "shorts"
                            sceneKitView.replaceNode(named: "Pants", named: "AvatarNodes/Male/Legs/MDefaultShorts")
                            
                        case 1: //from sweatpants to pants
                        
                            pantsStyle = "pants"
                            sceneKitView.replaceNode(named: "sweatPants", named: "AvatarNodes/Male/Legs/MDefaultPants")
                         
                            
                        case 2: //can't happen
                            print("Do nothing")

                        default:
                            print("Do nothing")
                            
                            
                        } //end switch
                        
                        sceneKitView.changePantsColor(named: pantsStyle, named: pantsColorOptions[selectedPantsColorIndex])
                        
                    }
                    
                    
                    
                }
                .foregroundColor(selectedPantsIndex == 0 ? .gray : .green)
                .padding(.all, 2)
                .font(.system(size: 28))
                .buttonStyle(NeumorphicButtonStyle())
                
                
                // Display the selected hairstyle and hair color
                Text("\(pantsOptions[selectedPantsIndex])")
                    .font(.system(size: 18))
                    .foregroundColor(Color("LightGray"))
                    .frame(width: 200, height: 40)
                    .background(Color("GradientLight"))
                    .cornerRadius(5)
                    .padding(.horizontal, 10)
                    
                
                
                // Right arrow button for pants selection
                Button(">") {
        
                    
                    selectedPantsColorIndex = 0
                    
                    if selectedPantsIndex <= 1 { //do not exceed array length
                        
                        selectedPantsIndex += 1
                        
                        
                        switch selectedPantsIndex {
                            
                        case 0:
                            
                         print("Do nothing") //won't ever happen
                            
                        case 1: //replace shorts with pants
                        
                            sceneKitView.replaceNode(named: "Shorts", named: "AvatarNodes/Male/Legs/MDefaultPants")
                            pantsStyle = "pants"
                         
                            
                        case 2: //replace tank top with sweater
                           
                            sceneKitView.replaceNode(named: "Pants", named: "AvatarNodes/Male/Legs/sweatpants")
                            pantsStyle = "sweatpants"
    
                        default:
                            
                            print("Do nothing")
                            
                            
                        } //end switch
                        
                        sceneKitView.changePantsColor(named: pantsStyle, named: pantsColorOptions[0])
                        
                    } //end if
                    
                    
                    
                    
                    
                }
                .foregroundColor(selectedPantsIndex == 2 ? .gray : .green)
                .padding(.all, 2)
                .font(.system(size: 28))
                .buttonStyle(NeumorphicButtonStyle())
                
                
                Spacer()
                
            } //end HStack for style selector
            .padding(.bottom, 10)
        
            
            
            
            
            
            
            if selectedPantsIndex != 2 { //if prevent sweatpants color
                
                Text("Select Color")
                    .font(.system(size: 18))
                    .foregroundColor(Color("LightGray"))
                
                HStack { //for color selector
                  
                    
                    Spacer()
                    
                    
                    // Left arrow button for shirt color
                    Button("<") {
                        
                        
                        if selectedPantsColorIndex >= 1 && selectedPantsColorIndex != 0 {
                            
                            selectedPantsColorIndex -= 1
                            
                            sceneKitView.changePantsColor(named: pantsStyle, named: pantsColorOptions[selectedPantsColorIndex])
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                    }
                    .foregroundColor(selectedPantsColorIndex == 0 ? .gray : .green)
                    .padding(.all, 2)
                    .font(.system(size: 28))
                    .buttonStyle(NeumorphicButtonStyle())

                        
                    ZStack {
                        
                        Rectangle()
                            .frame(width: 200, height: 40)
                            .foregroundColor(Color("GradientLight"))
                            .cornerRadius(5)
                            .padding(.horizontal, 10)
                        
                        Rectangle()
                            .frame(width: 150, height: 20)
                            .foregroundColor(Color(UIColor(hexString: pantsColorOptions[selectedPantsColorIndex])!))
                            .cornerRadius(5)
                        
                    }
                    
                    
                    // Right arrow button for pants color
                    Button(">") {
                        
                        if selectedPantsColorIndex <= 3 {
                 
                            selectedPantsColorIndex += 1
                            
                            sceneKitView.changePantsColor(named: pantsStyle, named: pantsColorOptions[selectedPantsColorIndex])
                            
                        }
                        
                    }
                    .foregroundColor(selectedPantsColorIndex == 4 ? .gray : .green)
                    .padding(.all, 2)
                    .font(.system(size: 28))
                    .buttonStyle(NeumorphicButtonStyle())
                    
                    
                    Spacer()
                    
                    
                }//end HStack for color selector
                
                
            } //end if prevent sweatpants color
             
            
            
            
            
            
            
        } //end VStack for style and color selectors
        .padding(.bottom, 60)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .background(.black)
        
    } //end body
    
    
    
}



struct PantContentView: View {
    
    
    @State private var sceneKitView = SceneKitView(named: "CamTest6", skinColor: "#ffdab0")
    
    var body: some View {
        
        VStack {
            
            sceneKitView
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
            
            PantSwitcherView(sceneKitView: $sceneKitView)
            
        }
        
        
        
    }
    
}



struct PantSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        PantContentView()
    }
}
