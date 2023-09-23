//
//  HairSwitcherView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/21/23.
//

import SwiftUI

struct HairSwitcherView: View {
    
    @Binding var sceneKitView: SceneKitView
    
    @State var selectedStyle: String = "Nil"
    
    
    var body: some View {
        
        VStack {
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(spacing: 20) { // Adjust the spacing between items as needed
                    
                    
                    
                    ZStack {
                        
                        Image(systemName: "square")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color("LightGray"))
                        
                        
                        Text("Anh hair")
                            .font(.system(size: 8))
                            .frame(width: 60, height: 25)
                            .foregroundColor(Color("LightGray"))
                        
                    }
                    .onTapGesture {
                        sceneKitView.addNode(named: "AvatarNodes/Male/Hair/AnhHair1")
                        selectedStyle = "AnhHair1"
                        
                    }
                    
                    
                    
                    
                    ZStack {
                        
                        Image(systemName: "square")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color("LightGray"))
                        
                        
                        Text("Elena hair")
                            .font(.system(size: 8))
                            .frame(width: 60, height: 25)
                            .foregroundColor(Color("LightGray"))
                        
                    }
                    .onTapGesture {
                        sceneKitView.addNode(named: "AvatarNodes/Male/Hair/elenahair")
                        selectedStyle = "elenahair"
                    }
                    
                    
                    ZStack {
                        
                        Image(systemName: "square")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color("LightGray"))
                        
                        
                        Text("Mohawk")
                            .font(.system(size: 8))
                            .frame(width: 60, height: 25)
                            .foregroundColor(Color("LightGray"))
                        
                    }
                    .onTapGesture {
                        sceneKitView.addNode(named: "AvatarNodes/Male/Hair/Mohwawk")
                        selectedStyle = "mohawk"
                    }
                    
                    
                    
                    ZStack {
                        
                        Image(systemName: "square")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color("LightGray"))
                        
                        
                        Text("Afro")
                            .font(.system(size: 8))
                            .frame(width: 60, height: 25)
                            .foregroundColor(Color("LightGray"))
                        
                    }
                    .onTapGesture {
                        sceneKitView.addNode(named: "AvatarNodes/Male/Hair/afro")
                        selectedStyle = "afro"
                    }
                    
                    
                    
                    
                    ZStack {
                        
                        Image(systemName: "square")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color("LightGray"))
                        
                        
                        Text("Long Hair")
                            .font(.system(size: 8))
                            .frame(width: 60, height: 25)
                            .foregroundColor(Color("LightGray"))
                        
                    }
                    .onTapGesture {
                        sceneKitView.addNode(named: "AvatarNodes/Male/Hair/longhair")
                        selectedStyle = "longhair"
                    }
                    
                    
                    
                    ZStack {
                        
                        Image(systemName: "square")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color("LightGray"))
                        
                        
                        Text("Short Hair")
                            .font(.system(size: 8))
                            .frame(width: 60, height: 25)
                            .foregroundColor(Color("LightGray"))
                        
                    }
                    .onTapGesture {
                        sceneKitView.addNode(named: "AvatarNodes/Male/Hair/shorthair")
                        selectedStyle = "shorthair"
                    }
                    
                    
                    
                    
                    ZStack {
                        
                        Image(systemName: "square")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color("LightGray"))
                        
                        
                        Text("Buzz cut")
                            .font(.system(size: 8))
                            .frame(width: 60, height: 25)
                            .foregroundColor(Color("LightGray"))
                        
                    }
                    .onTapGesture {
                        sceneKitView.addNode(named: "AvatarNodes/Male/Hair/buzzcut")
                        selectedStyle = "buzzcut"
                    }
                    
                    ZStack {
                        
                        Image(systemName: "square")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color("LightGray"))
                        
                        
                        Text("curly")
                            .font(.system(size: 8))
                            .frame(width: 60, height: 25)
                            .foregroundColor(Color("LightGray"))
                        
                    }
                    .onTapGesture {
                        sceneKitView.addNode(named: "AvatarNodes/Male/Hair/curly")
                        selectedStyle = "curly"
                    }
                    
                    ZStack {
                        
                        Image(systemName: "square")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color("LightGray"))
                        
                        
                        Text("curly2")
                            .font(.system(size: 8))
                            .frame(width: 60, height: 25)
                            .foregroundColor(Color("LightGray"))
                        
                    }
                    .onTapGesture {
                        sceneKitView.addNode(named: "AvatarNodes/Male/Hair/curly2")
                        selectedStyle = "curly2"
                    }
                    
                    ZStack {
                        
                        Image(systemName: "square")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color("LightGray"))
                        
                        
                        Text("curly3")
                            .font(.system(size: 8))
                            .frame(width: 60, height: 25)
                            .foregroundColor(Color("LightGray"))
                        
                    }
                    .onTapGesture {
                        sceneKitView.addNode(named: "AvatarNodes/Male/Hair/curly3")
                        selectedStyle = "curly3"
                    }
                    
                    /*
                     ZStack {
                     
                     Image(systemName: "square")
                     .resizable()
                     .frame(width: 60, height: 60)
                     .foregroundColor(Color("LightGray"))
                     
                     
                     Text("flattop")
                     .font(.system(size: 8))
                     .frame(width: 60, height: 25)
                     .foregroundColor(Color("LightGray"))
                     
                     }
                     .onTapGesture {
                     sceneKitView.addNode(named: "AvatarNodes/Male/Hair/flattop")
                     
                     }
                     */
                    
                } //end HStack
                
            } //end ScrollView
            .padding(.all, 10)
            
            
            
            HStack(spacing: 20) {
            
                
                ZStack {
                    
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color("LightGray"))
                        .zIndex(1)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(UIColor(hexString: "#141414")!)) //black color
                        .zIndex(0)
                    
                    
                }
                .onTapGesture {
                    sceneKitView.changeHairColor(named: selectedStyle, named: "#141414")
                    //selectionsArray[0] = "#ffdab0"
                }
                
                ZStack {
                    
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color("LightGray"))
                        .zIndex(1)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(UIColor(hexString: "#3d3d3d")!)) //black color
                        .zIndex(0)
                    
                    
                }
                .onTapGesture {
                    sceneKitView.changeHairColor(named: selectedStyle, named: "#3d3d3d")
                    //selectionsArray[0] = "#ffdab0"
                }
                
                ZStack {
                    
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color("LightGray"))
                        .zIndex(1)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(UIColor(hexString: "#a37d5a")!)) //brown color
                        .zIndex(0)
                    
                    
                }
                .onTapGesture {
                    sceneKitView.changeHairColor(named: selectedStyle, named: "#a37d5a")
                    //selectionsArray[0] = "#faba73"
                }
                
                
                ZStack {
                    
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color("LightGray"))
                        .zIndex(1)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(UIColor(hexString: "#d9d9d9")!))
                        .zIndex(0)
                    
                    
                }
                .onTapGesture {
                    sceneKitView.changeHairColor(named: selectedStyle, named: "#d9d9d9")
                    //selectionsArray[0] = "#a37d5a"
                }
                
                ZStack {
                    
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color("LightGray"))
                        .zIndex(1)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(UIColor(hexString: "#d4c7a7")!)) //black color
                        .zIndex(0)
                    
                    
                }
                .onTapGesture {
                    sceneKitView.changeHairColor(named: selectedStyle, named: "#d4c7a7")
                    //selectionsArray[0] = "#a37d5a"
                }
                
                
                
                
            } //end color HStack
            
        } //end main vstack
        .background(.black)
        
 
        
        
    } //end body
    
    
}

struct HairContentView: View {
    
    
    @State private var sceneKitView = SceneKitView(named: "CamTest6", skinColor: "#ffdab0")
    
    var body: some View {
        
        HairSwitcherView(sceneKitView: $sceneKitView)
        
    }
    
}



struct HairSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        HairContentView()
    }
}
