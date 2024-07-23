//
//  CommentCount.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 7/6/23.
//

import SwiftUI

struct CommentButton: View {
    // MARK: - Properties
    @State var commentCount: Int

    // MARK: - Body
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "message")
                .foregroundColor(Color.white.opacity(0.7))
                .imageScale(.small)
                .padding(.trailing, 5)
            
            Text(formatNumber(commentCount))
                .font(.system(size: 14))
                .foregroundColor(.white).opacity(0.7)
        }
    }

    // MARK: - Functions
    func formatNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
}

// MARK: - Preview
struct CommentButton_Previews: PreviewProvider {
    static var previews: some View {
        CommentButton(commentCount: 1000)
            .frame(width: UIScreen.main.bounds.width)
            .background(.black)
    }
}
