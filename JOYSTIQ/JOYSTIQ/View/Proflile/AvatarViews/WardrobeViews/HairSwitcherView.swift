//
//  HairSwitcherView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/21/23.
//

import SwiftUI

struct HairSwitcherView: View {
    
    @Binding var sceneKitView: SceneKitView
    
    // Define your hairstyle and hair color options as arrays
    let hairstyleOptions = ["Style 0", "Style 1", "Style 2", "Style 3", "Style 4", "Style 5", "Style 6", "Style 7", "Style 8", "Style 9", "Style 10"]
    //let hairstyles =  ["shorthair", "buzzcut", "curly", "curly2", "curly3", "elenahair", "anhhair", "afro", "mohawk"]
    
    //let hairColorOptions = ["Black", "Brown", "Blonde", "Red", "White"]
    let hairColorCodes =  ["#121212", "#7a5820", "#faf0be", "#943400", "#ffffff"]
    
    @State private var currentStyle = "nil"
    
    @State private var selectedHairstyleIndex = 0
    @State private var selectedHairColorIndex = 0
    
    var body: some View {
        
        VStack {
            
            Text("Select style")
                .font(.system(size: 18))
                .foregroundColor(Color.white)
            
            HStack (spacing: 5) {
                
                Spacer()
                
                // Left arrow button for hairstyle
                Button("<") {
                    
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
                .foregroundColor(selectedHairstyleIndex == 0 ? .gray : .green)
                .font(.system(size: 28))
                .frame(width: 40, height: 40)
                .background(Color("GradientLight"))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.8), radius: 2, x: 2, y: 2)
                .shadow(color: Color.white.opacity(0.4), radius: 2, x: -1, y: -1)
                
                
                // Display the selected hairstyle and hair color
                Text("\(hairstyleOptions[selectedHairstyleIndex])")
                    .font(.system(size: 18))
                    .foregroundColor(Color("LightGray"))
                    .frame(width: 200, height: 40)
                    .background(Color("GradientLight"))
                    .cornerRadius(5)
                    .padding(.horizontal, 10)
                    .shadow(color: Color.black.opacity(0.8), radius: 2, x: 2, y: 2)
                    .shadow(color: Color.white.opacity(0.4), radius: 2, x: -1, y: -1)
                
                
                // Right arrow button for hairstyle
                Button(">") {
        
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
                .foregroundColor(selectedHairstyleIndex == 10 ? .gray : .green)
                .font(.system(size: 28))
                .frame(width: 40, height: 40)
                .background(Color("GradientLight"))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.8), radius: 2, x: 2, y: 2)
                .shadow(color: Color.white.opacity(0.4), radius: 2, x: -1, y: -1)
                
                
                Spacer()
                
            } //end HStack for style selector
            .padding(.bottom, 10)
        
            
            
            Text("Select color")
                .font(.system(size: 18))
                .foregroundColor(Color.white)
                
            
            
            
            HStack {
                
                Spacer()
                
                // Left arrow button for hair color
                Button("<") {
                    
                    if selectedHairColorIndex >= 1 {
                        selectedHairColorIndex -= 1
                        
                        sceneKitView.changeHairColor(named: currentStyle, named: hairColorCodes[selectedHairColorIndex])
                        sceneKitView.changeEyebrow(named: hairColorCodes[selectedHairColorIndex])
                    }
                    
                }
                .foregroundColor(selectedHairColorIndex == 0 ? .gray : .green)
                .font(.system(size: 28))
                .frame(width: 40, height: 40)
                .background(Color("GradientLight"))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.8), radius: 2, x: 2, y: 2)
                .shadow(color: Color.white.opacity(0.4), radius: 2, x: -1, y: -1)
                
                
                ZStack {
                    
                    Rectangle()
                        .frame(width: 200, height: 40)
                        .foregroundColor(Color("GradientLight"))
                        .cornerRadius(5)
                        .padding(.horizontal, 10)
                        .shadow(color: Color.black.opacity(0.8), radius: 2, x: 2, y: 2)
                        .shadow(color: Color.white.opacity(0.4), radius: 2, x: -1, y: -1)
                    
                    Rectangle()
                        .frame(width: 150, height: 20)
                        .foregroundColor(Color(UIColor(hexString: hairColorCodes[selectedHairColorIndex])!))
                        .cornerRadius(5)
                }
                    
                
                
                // Right arrow button for hair color
                // hairColorOptions = ["Black", "Brown", "Blonde", "Red", "White"]
                Button(">") {
                    
                    //selectedHairColorIndex = (selectedHairColorIndex + 1) % hairColorOptions.count
                    
                    if selectedHairColorIndex <= 3 {
                        selectedHairColorIndex += 1
                        
                        sceneKitView.changeHairColor(named: currentStyle, named: hairColorCodes[selectedHairColorIndex])
                        sceneKitView.changeEyebrow(named: hairColorCodes[selectedHairColorIndex])
                        
                    } //end if
                    
    
                    
                }
                .foregroundColor(selectedHairColorIndex == 4 ? .gray : .green)
                .font(.system(size: 28))
                .frame(width: 40, height: 40)
                .background(Color("GradientLight"))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.8), radius: 2, x: 2, y: 2)
                .shadow(color: Color.white.opacity(0.4), radius: 2, x: -1, y: -1)
                
                
                Spacer()
                
                
            }//end HStack for color selector
            
            
            
            
            
            
        } //end VStack for style and color selectors
        .padding(.bottom, 60)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .background(Color("GradientDark"))
        
    } //end body
    
    
    
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
