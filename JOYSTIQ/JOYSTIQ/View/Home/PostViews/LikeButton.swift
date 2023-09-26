//
//  LikeButton.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 6/21/23.
//

import SwiftUI

struct LikeButton: View {
    
    @Binding var isLiked: Bool
    @Binding var likesCount: Int?
    
    //vibration for like button click
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        
        HStack(spacing: 0) { //for like button and like counter
            
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .foregroundColor(isLiked ? .red : .white.opacity(0.7))
                .imageScale(.small)
                .padding(.trailing, 5)
        
            if let count = likesCount {
                Text(formatNumber(count))
                    .font(.system(size: 14))
                    .foregroundColor(.white).opacity(0.7)
            }
            
        } //end Hstack for like button and like count
        
    } //end body
    
    func formatNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    } //end formatNumber func
}

struct LikeButton_Previews: PreviewProvider {
    static var previews: some View {
        LikeButton(isLiked: .constant(false), likesCount: .constant(1234456))
            .frame(width: UIScreen.main.bounds.width)
            .background(Color.black)
    }
}
