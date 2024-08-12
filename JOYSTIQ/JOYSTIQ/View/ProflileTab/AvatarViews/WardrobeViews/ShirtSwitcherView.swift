//
//  ShirtSwitcherView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/21/23.
//

import SwiftUI

struct ShirtSwitcherView: View {
    
    @Binding var sceneKitView: SceneKitView
    let torsoOptions = ["Shirt 1", "Shirt 2", "Shirt 3"]
    let torsoColorOptions = ["#025901", "#044bbd", "#780000", "#212121", "#d7d7d9"]
    @State private var shirtStyle = "Shirt"
    @State private var selectedTorsoIndex = 0
    @State private var selectedTorsoColorIndex = 0
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                Spacer()
                //left button for shirt selection
                Button(action: {
                    leftButtonAction()
                }) {
                    Image(systemName: "chevron.backward.square.fill")
                        .resizable()
                        .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                        .foregroundColor(selectedTorsoIndex == 0 ? Color("LightGray").opacity(0.2) : Color("LightGray"))
                }
                     
                // Display the selected shirt style
                Text("\(torsoOptions[selectedTorsoIndex])")
                    .frame(width: ScreenUtil.width * 0.4, height: ScreenUtil.width * 0.11)
                    .font(.system(size: 20))
                    .foregroundColor(Color.black)
                    .background(Color("LightGray"))
                    .cornerRadius(5)
                    .padding(.horizontal, 10)
   
                // Right arrow button for shirt selection
                Button(action: {
                    rightButtonAction()
                }) {
                    Image(systemName: "chevron.forward.square.fill")
                        .resizable()
                        .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                        .foregroundColor(selectedTorsoIndex == 2 ? Color("LightGray").opacity(0.2) : Color("LightGray"))
                }

                Spacer()
            } //end HStack for style selector
            .padding(.bottom, 20)
        
        
            if selectedTorsoIndex != 2 { //sweater does not allow color changes - don't show picker
                
                HStack { //for color selector ["Red", "Green", "Blue", "Black", "White"]
                    
                    Spacer()
                    
                    // Left arrow button for shirt color
                    Button(action: {
                        if selectedTorsoColorIndex >= 1 && selectedTorsoColorIndex != 0 {
                            selectedTorsoColorIndex -= 1
                            sceneKitView.changeShirtColor(named: shirtStyle, named: torsoColorOptions[selectedTorsoColorIndex])
                        }
                    }) {
                        Image(systemName: "chevron.backward.square.fill")
                            .resizable()
                            .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                            .foregroundColor(selectedTorsoColorIndex == 0 ? Color("LightGray").opacity(0.2) : Color("LightGray"))
                    }
                   
                    ZStack {
                        Rectangle()
                            .frame(width: ScreenUtil.width * 0.4, height: ScreenUtil.width * 0.11)
                            .foregroundColor(Color("LightGray"))
                            .cornerRadius(5)
                            .padding(.horizontal, 10)
                        
                        Rectangle()
                            .frame(width: ScreenUtil.width * 0.38, height: ScreenUtil.width * 0.09)
                            .foregroundColor(Color(UIColor(hexString: torsoColorOptions[selectedTorsoColorIndex])!))
                            .cornerRadius(5)
                    }
                    
                    // Right arrow button for shirt color
                    Button(action: {
                        if selectedTorsoColorIndex <= 3 {
                            selectedTorsoColorIndex += 1
                            sceneKitView.changeShirtColor(named: shirtStyle, named: torsoColorOptions[selectedTorsoColorIndex])
                        }
                    }) {
                        Image(systemName: "chevron.forward.square.fill")
                            .resizable()
                            .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                            .foregroundColor(selectedTorsoColorIndex == 4 ? Color("LightGray").opacity(0.2) : Color("LightGray"))
                    }
                    
                    Spacer()

                }//end HStack for color selector
            } //end if prevent sweater color
        } //end VStack for style and color selectors
    } //end body
    
    func leftButtonAction() {
        selectedTorsoColorIndex = 0
        if selectedTorsoIndex >= 1 && selectedTorsoIndex != 0 {
            selectedTorsoIndex -= 1
            switch selectedTorsoIndex {
            case 0: //from tanktop to shirt
                shirtStyle = "Shirt"
                sceneKitView.removeNode(named: "LogoTrasnparent")
                sceneKitView.replaceNode(named: "Tanktop", named: "AvatarNodes/Male/Torso/MDefaultShirt")
            case 1: //replace sweater with tank tpp
                shirtStyle = "Tanktop"
                sceneKitView.replaceNode(named: "sweater_black", named: "AvatarNodes/Male/Torso/MTanktop")
                sceneKitView.changeShirtColor(named: shirtStyle, named: torsoColorOptions[0])
            case 2:
                print("ShirtSwitcherView: Do nothing")
            default:
                print("ShirtSwitcherView: Do nothing")
            } //end switch
        }//end if
    }
    
    func rightButtonAction() {
        selectedTorsoColorIndex = 0
        if selectedTorsoIndex <= 1 { //do not exceed array length
            selectedTorsoIndex += 1
            switch selectedTorsoIndex {
            case 0:
             print("ShirtSwitcherView: Do nothing") //won't ever happen
            case 1: //replace shirt with tank top
                sceneKitView.replaceNode(named: "Shirt", named: "AvatarNodes/Male/Torso/MTanktop")
                shirtStyle = "Tanktop"
                sceneKitView.changeShirtColor(named: shirtStyle, named: torsoColorOptions[0])
            case 2: //replace tank top with sweater
                sceneKitView.removeNode(named: "LogoTrasnparent")
                sceneKitView.replaceNode(named: "Tanktop", named: "AvatarNodes/Male/Torso/blacksweater")
                shirtStyle = "sweater"
            default:
                print("ShirtSwitcherView: Do nothing")
            } //end switch
        } //end if
    }
    
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
