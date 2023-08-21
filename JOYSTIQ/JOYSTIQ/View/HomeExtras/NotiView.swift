//
//  NotiView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 6/29/23.
//

import SwiftUI

struct NotiView: View {
    
    var body: some View {
        
        HStack() { //HStack for username + comment string
            
            Text("user123 liked your post.")
                .font(.system(size: 14))
                .foregroundColor(.white)
                .lineLimit(3)
                .padding(.all, 8)
                .background(Rectangle()
                    .foregroundColor(Color.black)
                    .border(Color("LightGray")))

            Spacer()
            
        } //END HStack for comment
        .padding(.bottom, 10)
        .frame(width: UIScreen.main.bounds.width - 30)
        
    }
    
}

struct NotiView_Previews: PreviewProvider {
    static var previews: some View {
        NotiView()
    }
}
