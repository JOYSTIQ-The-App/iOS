//
//  WardrobeView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/10/23.
//

import SwiftUI

struct WardrobeView: View {
    
    //@Binding var sceneView: SceneKitView
    let sceneKitView = SceneKitView(named: "skintone6")
    
    
    var body: some View {
        
        VStack (spacing: 0) { //Main VStack for sceneKitView and wardrobe controls
            
            
            Spacer()
                   
            sceneKitView
                .frame(height: UIScreen.main.bounds.height * 0.5)
            
            
            
            HStack { //for wardrobe controls
                
                Button( action: {
            
                    sceneKitView.addNode(named: "DefaultShirt")
                    
                    }, label: {
                        
                        Image(systemName: "tshirt.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.green)
                        
                    })
                
                Spacer()
                
                
                Button( action: {

                    sceneKitView.removeNode(named: "Shirt")
                    
                    }, label: {
                        
                        Image(systemName: "tshirt")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.green)
                        
                    })
                
                
                
                 
            } //end Hstack for wardrobe controls
            .padding(.horizontal, 50)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4)
            .background(.purple)
            
            
            
        } //end Main VStack for scenekitview and wardrobe controls
        .edgesIgnoringSafeArea(.all)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.blue)
        
    }
    
}


struct WardrobeView_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeView()
    }
}

