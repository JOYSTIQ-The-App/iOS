//
//  LikeButton.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 6/21/23.
//

import SwiftUI

struct LikeButton: View {
    
    @State private var isLiked = false
    @State private var likesCount: Int
    
    init(likesCount: Int) {
            self.likesCount = likesCount
        }

    
    var body: some View {
        
        HStack(spacing: 0) { //for like buttona and like counter
            
            Button(action: {
                
                if (isLiked) {
                    
                    likesCount -= 1
                    isLiked.toggle()
                    
                }
                else{
                    
                    likesCount += 1
                    isLiked.toggle()
                    
                }
                
                
            }) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundColor(isLiked ? .red : .white.opacity(0.8))
                    .imageScale(.medium)
                    .padding(.trailing, 5)
            }
            
            Text(formatNumber(likesCount))
                .foregroundColor(.white).opacity(0.8)
            
        } //end Hstack for like button and like count

        
    } //end body
    
    
    func formatNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    } //end func

    
}

struct LikeButton_Previews: PreviewProvider {
    static var previews: some View {
        LikeButton(likesCount: 0)
    }
}
