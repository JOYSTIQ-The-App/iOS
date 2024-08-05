//
//  InteractionButtonMenu.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 7/26/23.
//

import SwiftUI

struct SelfInteractionButtonMenu<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    @Binding var showCommentSection: Bool
    
    var apiService: APIServiceType
    var postId: Int
    @State var likesCount: Int? = nil
    @State var commentCount: Int
    @State var userLiked: Bool
    @State private var showComment: Bool = false

    // MARK: - Body
    var body: some View {
        HStack {
            likeButton
            commentButton
            
            Spacer()
        }
        .padding(.horizontal, 25)
        .padding(.bottom, 8)
    }

    // MARK: - Subviews
    private var likeButton: some View {
        return AnyView(
            Button(action: {
                print("Like button pressed on post id", postId)
                likeButtonAction()
            }) {
                HStack(spacing: 0) {
                    Image(systemName: userLiked ? "heart.fill" : "heart")
                        .foregroundColor(userLiked ? .red : .white.opacity(0.7))
                        .imageScale(.small)
                        .padding(.trailing, 5)
                    
                    if let count = likesCount {
                        Text(formatNumber(count))
                            .font(.system(size: 14))
                            .foregroundColor(.white).opacity(0.7)
                    }
                }

            }
            .padding(.trailing, 5)
        )
    }
    
    private var commentButton: some View {
        return AnyView(
            Button(action: {
                print("Comment button pressed on post id", postId)
                showComment = true
            }) {
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
            .sheet(isPresented: $showComment) {
                CommentSectionView<APIService>(apiService: apiService, postId: postId)
                    .presentationDetents([.fraction(0.9)])
            }
        )
    }

    // MARK: - Functions
    private func likeButtonAction() {
        if userLiked {
            unlikePost()
            userLiked = false
        } else {
            likePost()
            userLiked = true
        }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
    }

    private func likePost() {
//        likesCount? += 1
        apiService.createLike(username: user.username, postId: postId) { result in
            switch result {
            case .success:
                userLiked.toggle()
            case .failure(let error):
                print("Error liking post: \(error.localizedDescription)")
            }
        }
    }

    private func unlikePost() {
//        likesCount? -= 1
        apiService.deleteLike(username: user.username, postId: postId) { result in
            switch result {
            case .success:
                userLiked.toggle()
            case .failure(let error):
                print("Error unliking post: \(error.localizedDescription)")
            }
        }
    }
    
    func formatNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
    
}

struct SelfInteractionButtonMenu_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "testUsername")
        
        return SelfInteractionButtonMenu<MockAPIService>(showCommentSection: .constant(false), apiService: MockAPIService(), postId: 1, likesCount: 1234, commentCount: 8, userLiked: true)
            .environmentObject(testUser)
            .background(Color("GradientDark3"))
    }
}
