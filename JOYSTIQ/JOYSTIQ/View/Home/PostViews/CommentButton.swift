//
//  CommentCount.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 7/6/23.
//

import SwiftUI

struct CommentButton<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    var APIService: APIServiceProtocol
    var postId: Int
    @State var commentCount: Int
    @State private var isShowingComments = false

    // MARK: - Body
    var body: some View {
        commentButtonContent
            .onTapGesture {
                isShowingComments.toggle()
            }
            .sheet(isPresented: $isShowingComments) {
                CommentSectionView<APIService>(APIService: APIService, postId: postId)
            }
    }

    // MARK: - Subviews
    private var commentButtonContent: some View {
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
        CommentButton<MockAPIService>(APIService: MockAPIService(), postId: 1, commentCount: 0)
            .frame(width: UIScreen.main.bounds.width)
            .background(.black)
    }
}
