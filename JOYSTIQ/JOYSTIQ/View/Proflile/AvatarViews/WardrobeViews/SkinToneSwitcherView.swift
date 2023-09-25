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
                .foregroundColor(Color.white)
                
            
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
                .font(.system(size: 28))
                .frame(width: 40, height: 40)
                .background(Color("GradientLight"))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.8), radius: 2, x: 2, y: 2)
                .shadow(color: Color.white.opacity(0.4), radius: 2, x: -1, y: -1)
                
                Spacer()
                
                
            }//end HStack for color selector
            
            
        } //end main VStack
        .padding(.bottom, 60)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .background(Color("GradientDark"))
        
        
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
