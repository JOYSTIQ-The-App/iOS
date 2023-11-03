//
//  ShoeSwitcherView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/23/23.
//

import SwiftUI

struct ShoeSwitcherView: View {
    
    @Binding var sceneKitView: SceneKitView
    
    // Define your hairstyle and hair color options as arrays
    let ShoeOptions = ["Shoes 0", "Shoes 1", "Shoes 2", "Shoes 3"]
    
    
    @State private var selectedShoeIndex = 0
    
    var body: some View {
        
        VStack {
            
            Text("Select Shoes")
                .font(.system(size: 18))
                .foregroundColor(Color.white)
            
            HStack (spacing: 5) {
                
                
                Spacer()
                
                // Left arrow button for hairstyle
                Button("<") {
                    
                    
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
                    }
                    
                    
                    
                }
                .foregroundColor(selectedShoeIndex == 0 ? .gray : .green)
                .font(.system(size: 28))
                .frame(width: 40, height: 40)
                .background(Color("GradientLight"))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.8), radius: 2, x: 2, y: 2)
                .shadow(color: Color.white.opacity(0.4), radius: 2, x: -1, y: -1)
                
                
                // Display the selected hairstyle and hair color
                Text("\(ShoeOptions[selectedShoeIndex])")
                    .font(.system(size: 18))
                    .foregroundColor(Color("LightGray"))
                    .frame(width: 200, height: 40)
                    .background(Color("GradientLight"))
                    .cornerRadius(5)
                    .padding(.horizontal, 10)
                    .shadow(color: Color.black.opacity(0.8), radius: 2, x: 2, y: 2)
                    .shadow(color: Color.white.opacity(0.4), radius: 2, x: -1, y: -1)
                
                
                // Right arrow button for shirt selection
                Button(">") {
                    
                    if selectedShoeIndex <= 2 { //do not exceed array length
                        
                        selectedShoeIndex += 1
                        
                        
                        switch selectedShoeIndex {
                            
                        case 0:
                            
                         print("Do nothing") //won't ever happen
                            
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
                            
                            print("Do nothing")
                            
                            
                        } //end switch
                        
                    } //end if
                    
                    
                }
                .foregroundColor(selectedShoeIndex == 3 ? .gray : .green)
                .font(.system(size: 28))
                .frame(width: 40, height: 40)
                .background(Color("GradientLight"))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.8), radius: 2, x: 2, y: 2)
                .shadow(color: Color.white.opacity(0.4), radius: 2, x: -1, y: -1)

                Spacer()
                
            } //end HStack for style selector
            .padding(.bottom, 10)
        
            
            
        } //end VStack for style and color selectors
        .padding(.bottom, 60)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .background(Color("GradientDark"))
        
    } //end body
    
    
    
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
