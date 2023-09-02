//
//  CommentCount.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 7/6/23.
//

import SwiftUI

struct CommentCount: View {
    
    @State private var commentCount: Int
    
    init(commentCount: Int) {
            self.commentCount = commentCount
        }
    
    var body: some View {
        
        HStack(spacing: 0) { //for comment counter
            
            Text(formatNumber(commentCount))
                .foregroundColor(.white).opacity(0.8)
            
        } //end Hstack for like button and like count

        
    } //end body
    
    
    func formatNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    } //end func
    
    
}

struct CommentCount_Previews: PreviewProvider {
    static var previews: some View {
        CommentCount(commentCount: 0)
    }
}
