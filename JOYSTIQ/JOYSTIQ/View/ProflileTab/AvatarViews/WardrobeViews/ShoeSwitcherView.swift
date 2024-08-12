//
//  ShoeSwitcherView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/23/23.
//

import SwiftUI

struct ShoeSwitcherView: View {

    @Binding var sceneKitView: SceneKitView
    let ShoeOptions = ["Shoes 0", "Shoes 1", "Shoes 2", "Shoes 3"]
    @State private var selectedShoeIndex = 0
    
    var body: some View {
        
        VStack {
            HStack {    
                Spacer()
                
                // Left arrow button for hairstyle
                Button(action: {
                    leftButtonAction()
                }) {
                    Image(systemName: "chevron.backward.square.fill")
                        .resizable()
                        .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                        .foregroundColor(selectedShoeIndex == 0 ? Color("LightGray").opacity(0.2) : Color("LightGray"))
                }
                                
                // Display the selected hairstyle and hair color
                Text("\(ShoeOptions[selectedShoeIndex])")
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
                        .foregroundColor(selectedShoeIndex == 3 ? Color("LightGray").opacity(0.2) : Color("LightGray"))
                }

                Spacer() 
            } //end HStack for style selector
        } //end VStack
    } //end body
    
    func leftButtonAction() {
        if selectedShoeIndex >= 1 && selectedShoeIndex != 0 {
            selectedShoeIndex -= 1
            switch selectedShoeIndex {
            case 0: //from sneakers to nothing
                sceneKitView.removeNode(named: "Left_Shoe_2")
                sceneKitView.removeNode(named: "Left_Shoe_2_001")
                sceneKitView.removeNode(named: "Left_Shoe_3")
                sceneKitView.removeNode(named: "Left_Shoe_3_001")
                sceneKitView.removeNode(named: "Left_Shoe_3_002")
                sceneKitView.removeNode(named: "Left_Shoe_3_003")
                sceneKitView.removeNode(named: "Left_Shoe_3_004")
                sceneKitView.removeNode(named: "Left_Shoe_3_005")
                sceneKitView.removeNode(named: "Left_Shoe_3_006")
                sceneKitView.removeNode(named: "Left_Shoe_3_007")
                sceneKitView.removeNode(named: "Left_Sock")
                sceneKitView.removeNode(named: "Left_Sock_001")
            case 1: //from loafers to sneakers
                sceneKitView.removeNode(named: "Left_Shoe")
                sceneKitView.removeNode(named: "Left_Shoe_001")
                sceneKitView.removeNode(named: "Left_Shoe_2")
                sceneKitView.removeNode(named: "Left_Shoe_2_001")
                sceneKitView.removeNode(named: "Left_Shoe_3")
                sceneKitView.removeNode(named: "Left_Shoe_3_001")
                sceneKitView.removeNode(named: "Left_Shoe_4")
                sceneKitView.removeNode(named: "Left_Shoe_4_001")
                sceneKitView.removeNode(named: "Left_Shoe_5")
                sceneKitView.removeNode(named: "Left_Shoe_5_001")
                sceneKitView.addNode(named: "AvatarNodes/Male/Footwear/sneakers")
            case 2: //from slides to loafers
                sceneKitView.removeNode(named: "Cube_000")
                sceneKitView.removeNode(named: "Cube_001")
                sceneKitView.removeNode(named: "Cube_002")
                sceneKitView.removeNode(named: "Cube_003")
                sceneKitView.addNode(named: "AvatarNodes/Male/Footwear/loafers")
            default:
                print("Do nothing")
            } //end switch
        } //end if
    } //end func
    
    func rightButtonAction() {
        if selectedShoeIndex <= 2 { //do not exceed array length
            selectedShoeIndex += 1
            switch selectedShoeIndex {
            case 0:
             print("ShoeSwitcherView: Do nothing") //won't ever happen
            case 1: //from nothing to sneakers
            sceneKitView.addNode(named: "AvatarNodes/Male/Footwear/sneakers")
            case 2: //from sneakers to loafers
                sceneKitView.removeNode(named: "Left_Shoe_2")
                sceneKitView.removeNode(named: "Left_Shoe_2_001")
                sceneKitView.removeNode(named: "Left_Shoe_3")
                sceneKitView.removeNode(named: "Left_Shoe_3_001")
                sceneKitView.removeNode(named: "Left_Shoe_3_002")
                sceneKitView.removeNode(named: "Left_Shoe_3_003")
                sceneKitView.removeNode(named: "Left_Shoe_3_004")
                sceneKitView.removeNode(named: "Left_Shoe_3_005")
                sceneKitView.removeNode(named: "Left_Shoe_3_006")
                sceneKitView.removeNode(named: "Left_Shoe_3_007")
                sceneKitView.removeNode(named: "Left_Sock")
                sceneKitView.removeNode(named: "Left_Sock_001")
                sceneKitView.addNode(named: "AvatarNodes/Male/Footwear/loafers")
            case 3: //from loafers to slides
                sceneKitView.removeNode(named: "Left_Shoe")
                sceneKitView.removeNode(named: "Left_Shoe_001")
                sceneKitView.removeNode(named: "Left_Shoe_2")
                sceneKitView.removeNode(named: "Left_Shoe_2_001")
                sceneKitView.removeNode(named: "Left_Shoe_3")
                sceneKitView.removeNode(named: "Left_Shoe_3_001")
                sceneKitView.removeNode(named: "Left_Shoe_4")
                sceneKitView.removeNode(named: "Left_Shoe_4_001")
                sceneKitView.removeNode(named: "Left_Shoe_5")
                sceneKitView.removeNode(named: "Left_Shoe_5_001")
                sceneKitView.addNode(named: "AvatarNodes/Male/Footwear/flops")
            default:
                print("ShoeSwitcherView: Do nothing")
            } //end switch
        } //end if
    } //end func
}

struct ShoeContentView: View {
    @State private var sceneKitView = SceneKitView(named: "CamTest6", skinColor: "#ffdab0")
    var body: some View {
        VStack {
            sceneKitView
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
            ShoeSwitcherView(sceneKitView: $sceneKitView)
        }
    }
}

struct ShoeSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        ShoeContentView()
    }
}
