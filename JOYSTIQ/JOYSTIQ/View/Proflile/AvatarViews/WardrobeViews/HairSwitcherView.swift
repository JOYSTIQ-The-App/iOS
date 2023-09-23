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
    let hairstyleOptions = ["Style 0", "Style 1", "Style 2", "Style 3", "Style 4", "Style 5", "Style 6", "Style 7", "Style 8", "Style 9"]
    //let hairstyles =  ["shorthair", "buzzcut", "curly", "curly2", "curly3", "elenahair", "anhhair", "afro", "mohawk"]
    
    let hairColorOptions = ["Default", "Black", "Brown", "Blonde", "Red", "White"]
    
    @State private var currentStyle = "nil"
    
    @State private var selectedHairstyleIndex = 0
    @State private var selectedHairColorIndex = 0
    
    var body: some View {
        
        VStack {
            
            HStack (spacing: 5) {
                
                Image(systemName: "scissors.circle.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color("LightGray"))
                 
                
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
                        //remove mohawk cut for afro
                        sceneKitView.replaceNode(named: "Mohawk_Spikey_Solid", named: "AvatarNodes/Male/Hair/afro")
                        
                        /*
                    case 9:
                        currentStyle = "mohawk"
                        //remove flattop cut for mohawk
                        sceneKitView.replaceNode(named: "FlatTop", named: "AvatarNodes/Male/Hair/Mohwawk")
                        */
                        
                    default:
                
                        //do nothing
                        currentStyle = "bald"
                        
                        
                    }
                    
                    //below wraps list
                    //selectedHairstyleIndex = (selectedHairstyleIndex - 1 + hairstyleOptions.count) % hairstyleOptions.count
                    
                }
                .foregroundColor(selectedHairstyleIndex == 0 ? .gray : .green)
                .padding(.all, 2)
                .font(.system(size: 28))
                .buttonStyle(NeumorphicButtonStyle())
                
                
                // Display the selected hairstyle and hair color
                Text("\(hairstyleOptions[selectedHairstyleIndex])")
                    .font(.system(size: 18))
                    .foregroundColor(Color("LightGray"))
                    .frame(width: 200, height: 40)
                    .background(Color("GradientLight"))
                    .cornerRadius(5)
                    .padding(.horizontal, 10)
                    
                
                
                // Right arrow button for hairstyle
                Button(">") {
        
                    //below wraps list
                    //selectedHairstyleIndex = (selectedHairstyleIndex + 1) % hairstyleOptions.count
                    
                    selectedHairColorIndex = 0
                    
                    if selectedHairstyleIndex <= 8 { //do not exceed array length
                        
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
                            currentStyle = "mohawk"
                            //replace afro with mohawk
                            sceneKitView.replaceNode(named: "hair_sculpted", named: "AvatarNodes/Male/Hair/Mohwawk")
                            
                        /*
                        case 10:
                            
                            //replace mohawk with flattop
                            sceneKitView.replaceNode(named: "Mohawk_Spikey_Solid", named: "AvatarNodes/Male/Hair/flattop")
                            */
                            
                            
                        default:
                    
                            //do nothing
                            currentStyle = "bald"
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                }
                .foregroundColor(selectedHairstyleIndex == 9 ? .gray : .green)
                .padding(.all, 2)
                .font(.system(size: 28))
                .buttonStyle(NeumorphicButtonStyle())
                
                
                Spacer()
                
            } //end HStack for style selector
            .padding(.bottom, 10)
        
            
            
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
            
            
            
            
            
            
        } //end VStack for style and color selectors
        .padding(.bottom, 60)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .background(.black)
        
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
