//
//  PantSwitcherView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/23/23.
//

import SwiftUI

struct PantSwitcherView: View {
    
    @Binding var sceneKitView: SceneKitView
    let pantsOptions = ["Pants 1", "Pants 2", "Pants 3"]
    //["Blue", "Green", "Red", "Black", "White"]
    let pantsColorOptions = ["#044bbd", "#025901", "#780000", "#212121", "#d7d7d9"]
    @State private var pantsStyle = "shorts"
    @State private var selectedPantsIndex = 0
    @State private var selectedPantsColorIndex = 0
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                
                Spacer()
                
                // Left arrow button for pants selection
                Button(action: {
                    leftButtonAction()
                }) {
                    Image(systemName: "chevron.backward.square.fill")
                        .resizable()
                        .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                        .foregroundColor(selectedPantsIndex == 0 ? Color("LightGray").opacity(0.2) : Color("LightGray"))
                }
                
                // Display the selected pants style
                Text("\(pantsOptions[selectedPantsIndex])")
                    .frame(width: ScreenUtil.width * 0.4, height: ScreenUtil.width * 0.11)
                    .font(.system(size: 20))
                    .foregroundColor(Color.black)
                    .background(Color("LightGray"))
                    .cornerRadius(5)
                    .padding(.horizontal, 10)

                
                // Right arrow button for pants selection
                Button(action: {
                    rightButtonAction()
                }) {
                    Image(systemName: "chevron.forward.square.fill")
                        .resizable()
                        .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                        .foregroundColor(selectedPantsIndex == 2 ? Color("LightGray").opacity(0.2) : Color("LightGray"))
                }
                
                Spacer()
                
            } //end HStack for style selector
            .padding(.bottom, 20)
        
            
            if selectedPantsIndex != 2 { //prevent sweatpants color picker

                HStack { //for color selector
                
                    Spacer()
                    
                    // Left arrow button for shirt color
                    Button(action: {
                        if selectedPantsColorIndex >= 1 && selectedPantsColorIndex != 0 {
                            selectedPantsColorIndex -= 1
                            sceneKitView.changePantsColor(named: pantsStyle, named: pantsColorOptions[selectedPantsColorIndex])
                        }
                    }) {
                        Image(systemName: "chevron.backward.square.fill")
                            .resizable()
                            .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                            .foregroundColor(selectedPantsColorIndex == 0 ? Color("LightGray").opacity(0.2) : Color("LightGray"))
                    }
                   
                    ZStack {
                        Rectangle()
                            .frame(width: ScreenUtil.width * 0.4, height: ScreenUtil.width * 0.11)
                            .foregroundColor(Color("LightGray"))
                            .cornerRadius(5)
                            .padding(.horizontal, 10)
                        
                        Rectangle()
                            .frame(width: ScreenUtil.width * 0.38, height: ScreenUtil.width * 0.09)
                            .foregroundColor(Color(UIColor(hexString: pantsColorOptions[selectedPantsColorIndex])!))
                            .cornerRadius(5)
                    }
                    
                    // Right arrow button for pants color
                    Button(action: {
                        if selectedPantsColorIndex <= 3 {
                            selectedPantsColorIndex += 1
                            sceneKitView.changePantsColor(named: pantsStyle, named: pantsColorOptions[selectedPantsColorIndex])
                        }
                    }) {
                        Image(systemName: "chevron.forward.square.fill")
                            .resizable()
                            .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                            .foregroundColor(selectedPantsColorIndex == 4 ? Color("LightGray").opacity(0.2) : Color("LightGray"))
                    }
                    
                    Spacer()
                }//end HStack for color selector
            } //end if prevent sweatpants color
        } //end VStack for style and color selectors
    } //end body
    
    func leftButtonAction() {
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
                print("PantSwitcherView: Do nothing")
            default:
                print("PantSwitcherView: Do nothing")
            } //end switch
            sceneKitView.changePantsColor(named: pantsStyle, named: pantsColorOptions[selectedPantsColorIndex])
        }
    }
    
    func rightButtonAction() {
        selectedPantsColorIndex = 0
        if selectedPantsIndex <= 1 { //do not exceed array length
            selectedPantsIndex += 1
            switch selectedPantsIndex {
            case 0:
             print("PantSwitcherView: Do nothing") //won't ever happen
            case 1: //replace shorts with pants
                sceneKitView.replaceNode(named: "Shorts", named: "AvatarNodes/Male/Legs/MDefaultPants")
                pantsStyle = "pants"
            case 2: //replace tank top with sweater
                sceneKitView.replaceNode(named: "Pants", named: "AvatarNodes/Male/Legs/sweatpants")
                pantsStyle = "sweatpants"
            default:
                print("PantSwitcherView: Do nothing")
            } //end switch
            sceneKitView.changePantsColor(named: pantsStyle, named: pantsColorOptions[0])
        } //end if
    }
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
