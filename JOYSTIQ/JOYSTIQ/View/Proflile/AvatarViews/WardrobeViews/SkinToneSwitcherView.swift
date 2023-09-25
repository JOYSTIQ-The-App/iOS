//
//  SkinToneSwitcherView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/20/23.
//

import SwiftUI

struct SkinToneSwitcherView: View {
    
    @Binding var sceneKitView: SceneKitView
    
    // [Black, brown, blonde, red, white]
    let skinColorCodes =  ["#ffdab0", "#ffc380", "#bd9b7b", "#a37d5a", "#705032"]
    
    @State private var selectedSkinToneIndex = 0
    
    
    var body: some View {
        
        VStack {
            
            Text("Select Skin Tone")
                .font(.system(size: 18))
                .foregroundColor(Color("LightGray"))
                
            
            HStack {
                
                Spacer()
                
                // Left arrow button for skin tone selector
                Button("<") {
                    
                    if selectedSkinToneIndex >= 1 {
                        selectedSkinToneIndex -= 1
                        
                        sceneKitView.changeSkinTone(named: skinColorCodes[selectedSkinToneIndex])
                    }
                    
                }
                .foregroundColor(selectedSkinToneIndex == 0 ? .gray : .green)
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
                        .foregroundColor(Color(UIColor(hexString: skinColorCodes[selectedSkinToneIndex])!))
                        .cornerRadius(5)
                }
                    
                
                
                // Right arrow button for skin tone selector
                Button(">") {
                    
                    //selectedHairColorIndex = (selectedHairColorIndex + 1) % hairColorOptions.count
                    
                    if selectedSkinToneIndex <= 3 {
                        selectedSkinToneIndex += 1
                        
                       
                        sceneKitView.changeSkinTone(named: skinColorCodes[selectedSkinToneIndex])
                        
                    } //end if
                    
    
                    
                }
                .foregroundColor(selectedSkinToneIndex == 4 ? .gray : .green)
                .padding(.all, 2)
                .font(.system(size: 28))
                .buttonStyle(NeumorphicButtonStyle())
                
                
                Spacer()
                
                
            }//end HStack for color selector
            
            
        } //end main VStack
        .padding(.bottom, 60)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .background(.black)
        
        
    } //end body
    
    
}

struct ContentView9: View {
    
    
    @State private var sceneKitView = SceneKitView(named: "CamTest6", skinColor: "#ffdab0")
    
    var body: some View {
        
        VStack {
            
            sceneKitView
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
            
            SkinToneSwitcherView(sceneKitView: $sceneKitView)
            
        }
        
    }
    
}

struct SkinToneSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView9()
    }
}
