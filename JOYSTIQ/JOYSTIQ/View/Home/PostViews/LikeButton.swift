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
    
    //vibration for like button click
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    init(likesCount: Int) {
            self.likesCount = likesCount
        }

    
    var body: some View {
        
        HStack(spacing: 0) { //for like buttona and like counter
            
           
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .foregroundColor(isLiked ? .red : .white.opacity(0.8))
                .imageScale(.small)
                .padding(.trailing, 5)
        
            
            Text(formatNumber(likesCount))
                .font(.system(size: 14))
                .foregroundColor(.white).opacity(0.8)
            
        } //end Hstack for like button and like count
        .onTapGesture {
            
            if (isLiked) {
                
                likesCount -= 1
                isLiked.toggle()
                
            }
            else{
                impactFeedbackGenerator.impactOccurred()
                likesCount += 1
                isLiked.toggle()
                
            }
            
        }

        
    } //end body
    
    
    func formatNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    } //end formatNumber func

    
}

struct LikeButton_Previews: PreviewProvider {
    static var previews: some View {
        LikeButton(likesCount: 1234456).frame(width: UIScreen.main.bounds.width).background(.black)
    }
}
