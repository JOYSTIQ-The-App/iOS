//
//  CommentCount.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 7/6/23.
//

import SwiftUI

struct CommentButton: View {
    
    @State private var commentCount: Int
    

    
    init(commentCount: Int) {
            self.commentCount = commentCount
        }
    
    var body: some View {
        
        HStack(spacing: 0) { //for comment counter
            
            Image(systemName: "message")
                .foregroundColor(Color.white.opacity(0.8))
                .imageScale(.small)
                .padding(.trailing, 5)
            
            Text(formatNumber(commentCount))
                .font(.system(size: 14))
                .foregroundColor(.white).opacity(0.8)
            
        } //end Hstack for like button and like count
        

        
    } //end body
    
    
    func formatNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    } //end func
    
    
}

struct CommentButton_Previews: PreviewProvider {
    static var previews: some View {
        CommentButton(commentCount: 0).frame(width: UIScreen.main.bounds.width).background(.black)
    }
}
