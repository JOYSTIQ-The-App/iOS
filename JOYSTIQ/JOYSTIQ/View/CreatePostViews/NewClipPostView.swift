//
//  NewClipPostView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 4/28/23.
//

import SwiftUI

struct NewClipPostView: View {
    
    @State private var caption: String = ""
    
    var body: some View {
        
        Text("<<Video will go here>>")
            .frame(width: 300, height: 200)
            .foregroundColor(.red)
            .background(.black)
            .padding()
        
        VStack {
            
            TextEditor(text: $caption)
                .background(.red)
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 40, height: 100)
                .lineLimit(5)
                .border(Color.gray, width: 5)
            
        }
        
        .cornerRadius(15)
        .padding()
        
    }
}

struct NewClipPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewClipPostView()
    }
}
