//
//  HairSwitcherView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/21/23.
//

import SwiftUI

struct HairSwitcherView: View {
    
    @Binding var sceneKitView: SceneKitView

    //["shorthair", "buzzcut", "curly", "curly2", "curly3", "elenahair", "anhhair", "afro", "mohawk"]
    let hairstyleOptions = ["Style 1", "Style 2", "Style 3", "Style 4", "Style 5", "Style 6", "Style 7", "Style 8", "Style 9", "Style 10", "Style 11"]
    
    //["Black", "Brown", "Blonde", "Red", "White"]
    let hairColorCodes =  ["#121212", "#7a5820", "#faf0be", "#943400", "#ffffff"]
    
    @State private var currentStyle = "nil"
    @State private var selectedHairstyleIndex = 0
    @State private var selectedHairColorIndex = 0
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            
            
            HStack {
                
                Spacer()
                
                Button(action: {
                    leftButtonAction()
                }) {
                    Image(systemName: "chevron.backward.square.fill")
                        .resizable()
                        .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                        .foregroundColor(selectedHairstyleIndex == 0 ? Color("LightGray").opacity(0.2) : Color("LightGray"))
                }
                
                Text("\(hairstyleOptions[selectedHairstyleIndex])")
                    .frame(width: ScreenUtil.width * 0.4, height: ScreenUtil.width * 0.11)
                    .font(.system(size: 20))
                    .foregroundColor(Color.black)
                    .background(Color("LightGray"))
                    .cornerRadius(5)
                    .padding(.horizontal, 10)
                
                
                Button(action: {
                    rightButtonAction()
                }) {
                    Image(systemName: "chevron.forward.square.fill")
                        .resizable()
                        .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                        .foregroundColor(selectedHairstyleIndex == 10 ? Color("LightGray").opacity(0.2) : Color("LightGray"))
                }
                
                Spacer()
                
            } //end HStack for style selector
            .padding(.bottom, 20)
            
            
            HStack { // hairColorOptions = ["Black", "Brown", "Blonde", "Red", "White"]
                
                Spacer()
                
                Button(action: {
                    
                    if selectedHairColorIndex >= 1 {
                        selectedHairColorIndex -= 1
                        
                        sceneKitView.changeHairColor(named: currentStyle, named: hairColorCodes[selectedHairColorIndex])
                        sceneKitView.changeEyebrow(named: hairColorCodes[selectedHairColorIndex])
                    }
                    
                }) {
                    Image(systemName: "chevron.backward.square.fill")
                        .resizable()
                        .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                        .foregroundColor(selectedHairColorIndex == 0 ? Color("LightGray").opacity(0.2) : Color("LightGray"))
                }
                
                ZStack {
                    Rectangle()
                        .frame(width: ScreenUtil.width * 0.4, height: ScreenUtil.width * 0.11)
                        .foregroundColor(Color("LightGray"))
                        .cornerRadius(5)
                        .padding(.horizontal, 10)
                    
                    Rectangle()
                        .frame(width: ScreenUtil.width * 0.38, height: ScreenUtil.width * 0.09)
                        .foregroundColor(Color(UIColor(hexString: hairColorCodes[selectedHairColorIndex])!))
                        .cornerRadius(5)
                }
                
                // Right arrow button for hair color
                Button(action: {
                    if selectedHairColorIndex <= 3 {
                        selectedHairColorIndex += 1
                        
                        sceneKitView.changeHairColor(named: currentStyle, named: hairColorCodes[selectedHairColorIndex])
                        sceneKitView.changeEyebrow(named: hairColorCodes[selectedHairColorIndex])
                        
                    }
                }) {
                    Image(systemName: "chevron.forward.square.fill")
                        .resizable()
                        .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                        .foregroundColor(selectedHairColorIndex == 4 ? Color("LightGray").opacity(0.2) : Color("LightGray"))
                }
                
                Spacer()
                
            }//end HStack for color picker
        }//end VStack for both pickers
    } //end body
    
    func leftButtonAction() {
        selectedHairColorIndex = 0
        
        if selectedHairstyleIndex >= 1 {
            selectedHairstyleIndex -= 1
        }
        
        
        switch selectedHairstyleIndex {
            
        case 0:
            //bald, do nothing
            currentStyle = "bald"
            //remove short hair to bald styte
            sceneKitView.removeNode(named: "ShortHair")
            
        case 1:
            
            currentStyle = "shorthair"
            //remove buzz cut for shorthair
            sceneKitView.replaceNode(named: "Sphere", named: "AvatarNodes/Male/Hair/shorthair")
            
        case 2:
            currentStyle = "buzzcut"
            //remove curly for buzzcut
            sceneKitView.replaceNode(named: "curly_lv1", named: "AvatarNodes/Male/Hair/buzzcut")
            
        case 3:
            currentStyle = "curly"
            //remove curly2 for curly
            sceneKitView.replaceNode(named: "curly_lv2", named: "AvatarNodes/Male/Hair/curly")
            
        case 4:
            currentStyle = "curly2"
            //remove curly3 for curly2
            sceneKitView.replaceNode(named: "curly_lv4", named: "AvatarNodes/Male/Hair/curly2")
            
        case 5:
            currentStyle = "curly3"
            //remove elenahair for curly3
            sceneKitView.removeNode(named: "NurbsPath_001")
            sceneKitView.removeNode(named: "NurbsPath_002")
            sceneKitView.removeNode(named: "NurbsPath_003")
            sceneKitView.removeNode(named: "NurbsPath_004")
            sceneKitView.removeNode(named: "NurbsPath_005")
            sceneKitView.removeNode(named: "NurbsPath_006")
            sceneKitView.removeNode(named: "NurbsPath_007")
            sceneKitView.removeNode(named: "NurbsPath_008")
            sceneKitView.removeNode(named: "NurbsPath_009")
            sceneKitView.removeNode(named: "NurbsPath_010")
            sceneKitView.removeNode(named: "NurbsPath_011")
            sceneKitView.removeNode(named: "NurbsPath_012")
            sceneKitView.removeNode(named: "NurbsPath_013")
            sceneKitView.removeNode(named: "NurbsPath_014")
            sceneKitView.removeNode(named: "NurbsPath_015")
            sceneKitView.removeNode(named: "NurbsPath_016")
            sceneKitView.removeNode(named: "NurbsPath_017")
            
            //add anhhair
            sceneKitView.addNode(named: "AvatarNodes/Male/Hair/curly3")
            
            
        case 6:
            currentStyle = "elenahair"
            //remove anhhair cut for elenahair
            sceneKitView.removeNode(named: "ShortHair")
            sceneKitView.replaceNode(named: "TopPart", named: "AvatarNodes/Male/Hair/elenahair")
            
        case 7:
            currentStyle = "AnhHair1"
            //remove afro cut for anhair
            sceneKitView.replaceNode(named: "hair_sculpted", named: "AvatarNodes/Male/Hair/AnhHair1")
            
            
        case 8:
            currentStyle = "afro"
            //remove longhair cut for afro
            sceneKitView.removeNode(named: "NurbsPath")
            sceneKitView.replaceNode(named: "Sphere_003", named: "AvatarNodes/Male/Hair/afro")
            
            
        case 9:
            
            currentStyle = "longhair"
            //remove mohawk cut for longhair
            sceneKitView.replaceNode(named: "Mohawk_Spikey_Solid", named: "AvatarNodes/Male/Hair/longhair")
            
            
        default:
    
            //do nothing
            currentStyle = "bald"
            
            
        }
        
        sceneKitView.changeHairColor(named: currentStyle, named: "#121212")
        sceneKitView.changeEyebrow(named: "#121212")
    }
    
    func rightButtonAction() {
        //below wraps list
        //selectedHairstyleIndex = (selectedHairstyleIndex + 1) % hairstyleOptions.count
        
        selectedHairColorIndex = 0
        
        if selectedHairstyleIndex <= 9 { //do not exceed array length
            
            selectedHairstyleIndex += 1
            
            
            switch selectedHairstyleIndex {
                
            case 0:
                //bald, do nothing
                currentStyle = "bald"
                
            case 1:
                currentStyle = "shorthair"
                sceneKitView.addNode(named: "AvatarNodes/Male/Hair/shorthair")
                
            case 2:
                currentStyle = "buzzcut"
                sceneKitView.replaceNode(named: "ShortHair", named: "AvatarNodes/Male/Hair/buzzcut")
                
            case 3:
                currentStyle = "curly"
                //replace buzzcut with curly
                sceneKitView.replaceNode(named: "Sphere", named: "AvatarNodes/Male/Hair/curly")
                
            case 4:
                currentStyle = "curly2"
                //replace curly with curly2
                sceneKitView.replaceNode(named: "curly_lv1", named: "AvatarNodes/Male/Hair/curly2")
                
            case 5:
                currentStyle = "curly3"
                //replace curly2 with curly3
                sceneKitView.replaceNode(named: "curly_lv2", named: "AvatarNodes/Male/Hair/curly3")
                
            case 6:
                currentStyle = "elenahair"
                //replace curly3 with elenahair
                sceneKitView.replaceNode(named: "curly_lv4", named: "AvatarNodes/Male/Hair/elenahair")
                
            case 7:
                currentStyle = "AnhHair1"
                //remove elenahair
                sceneKitView.removeNode(named: "NurbsPath_001")
                sceneKitView.removeNode(named: "NurbsPath_002")
                sceneKitView.removeNode(named: "NurbsPath_003")
                sceneKitView.removeNode(named: "NurbsPath_004")
                sceneKitView.removeNode(named: "NurbsPath_005")
                sceneKitView.removeNode(named: "NurbsPath_006")
                sceneKitView.removeNode(named: "NurbsPath_007")
                sceneKitView.removeNode(named: "NurbsPath_008")
                sceneKitView.removeNode(named: "NurbsPath_009")
                sceneKitView.removeNode(named: "NurbsPath_010")
                sceneKitView.removeNode(named: "NurbsPath_011")
                sceneKitView.removeNode(named: "NurbsPath_012")
                sceneKitView.removeNode(named: "NurbsPath_013")
                sceneKitView.removeNode(named: "NurbsPath_014")
                sceneKitView.removeNode(named: "NurbsPath_015")
                sceneKitView.removeNode(named: "NurbsPath_016")
                sceneKitView.removeNode(named: "NurbsPath_017")
                
                //add anhhair
                sceneKitView.addNode(named: "AvatarNodes/Male/Hair/AnhHair1")
                
            case 8:
                currentStyle = "afro"
                //replace anhhair with afro
                sceneKitView.removeNode(named: "ShortHair")
                sceneKitView.replaceNode(named: "TopPart", named: "AvatarNodes/Male/Hair/afro")
                
            case 9:
                currentStyle = "longhair"
                //replace afro with longhair
                sceneKitView.replaceNode(named: "hair_sculpted", named: "AvatarNodes/Male/Hair/longhair")
                
            
            case 10:
                currentStyle = "mohawk"
                //replace longhair with mohawk
                sceneKitView.removeNode(named: "NurbsPath")
                sceneKitView.replaceNode(named: "Sphere_003", named: "AvatarNodes/Male/Hair/Mohwawk")
                
        
            default:
                //do nothing
                currentStyle = "bald"
                
                
            } //end switch
            
            sceneKitView.changeHairColor(named: currentStyle, named: "#121212")
            sceneKitView.changeEyebrow(named: "#121212")
            
        } //end if
    }
}
struct HairContentView: View {
    @State private var sceneKitView = SceneKitView(named: "CamTest6", skinColor: "#ffdab0")
    var body: some View {
        VStack {
            sceneKitView
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
            
            HairSwitcherView(sceneKitView: $sceneKitView)
        }
    }
}

struct HairSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        HairContentView()
    }
}
