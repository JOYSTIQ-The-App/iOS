//
//  CommentView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 6/28/23.
//

import SwiftUI

struct CommentView: View {
    var userName: String
    var commentString: String

    var body: some View {
        HStack(spacing: 15) {
            Image("TestAvatar4")
                .scaleEffect(0.18)
                .frame(width: 35, height: 35)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))

            VStack(alignment: .leading, spacing: 5) {
                Text(userName)
                    .foregroundColor(.gray)
                    .font(.system(size: 12))

                Text(commentString)
                    .foregroundColor(.white)
                    .font(.system(size: 14))
            }

            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Previews
struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(userName: "Username", commentString: "This is a comment")
            .background(Color.green)
    }
}
