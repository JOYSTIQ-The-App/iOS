//
//  SkinToneSwitcherView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/20/23.
//

import SwiftUI

struct SkinToneSwitcherView: View {
    
    @Binding var sceneKitView: SceneKitView
    let skinColorCodes =  ["#ffdab0", "#ffc380", "#bd9b7b", "#a37d5a", "#705032"]
    @State private var selectedSkinToneIndex = 0
    
    var body: some View {
        HStack {
            
            Spacer()
            
            Button(action: {
                
                if selectedSkinToneIndex >= 1 {
                    selectedSkinToneIndex -= 1
                    sceneKitView.changeSkinTone(named: skinColorCodes[selectedSkinToneIndex])
                }
                
            }) {
                Image(systemName: "chevron.backward.square.fill")
                    .resizable()
                    .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                    .foregroundColor(selectedSkinToneIndex == 0 ? Color("LightGray").opacity(0.2) : Color("LightGray"))
            }
            
            ZStack {
                
                Rectangle()
                    .frame(width: ScreenUtil.width * 0.4, height: ScreenUtil.width * 0.11)
                    .foregroundColor(Color("LightGray"))
                    .cornerRadius(5)
                    .padding(.horizontal, 10)
                
                Rectangle()
                    .frame(width: ScreenUtil.width * 0.38, height: ScreenUtil.width * 0.09)
                    .foregroundColor(Color(UIColor(hexString: skinColorCodes[selectedSkinToneIndex])!))
                    .cornerRadius(5)
            }
            
                
            Button(action: {
                if selectedSkinToneIndex <= 3 {
                    selectedSkinToneIndex += 1
                    sceneKitView.changeSkinTone(named: skinColorCodes[selectedSkinToneIndex])
                }
            }) {
                Image(systemName: "chevron.forward.square.fill")
                    .resizable()
                    .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                    .foregroundColor(selectedSkinToneIndex == 4 ? Color("LightGray").opacity(0.2) : Color("LightGray"))
            }
            
            Spacer()
            
        }//end HStack for skin tone selector
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
