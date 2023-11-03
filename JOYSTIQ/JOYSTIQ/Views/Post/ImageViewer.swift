//
//  ImageViewer.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 10/1/23.
//

import SwiftUI

struct ImageViewer: View {
    
    @Binding var showImageView: Bool
    let image: Image
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width)
                
                Spacer()
                
            }
            .background(Color.black)
            .onTapGesture {
                withAnimation {
                    showImageView = false
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        if gesture.translation.height > 100 {
                            withAnimation {
                                showImageView = false
                            }
                        }
                    }
            )
        }
        
        
    } //end body
}

struct ImageViewer_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewer(showImageView: .constant(true), image: Image("screenshot"))
    }
}
