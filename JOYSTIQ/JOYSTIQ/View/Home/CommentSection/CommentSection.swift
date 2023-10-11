//
//  CommentSection2.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/5/23.
//

import SwiftUI

struct CommentSectionView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    var apiService: APIServiceProtocol
    var postId: Int
    @State private var comments: [Comment] = []
    @State private var userComment: String = ""

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            headerView
            scrollView
            commentInputView
        }
        .background(Color("GradientDark3"))
        .onAppear(perform: fetchComments)
    }

    // MARK: - Subviews
    private var headerView: some View {
        VStack {
            Image("CommentsText3")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.25, height: 20)
                .padding(.top, 5)
        }
        .frame(width: UIScreen.main.bounds.width, height: 40)
        .background(Color("GradientDark"))
        .overlay(
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(width: UIScreen.main.bounds.width, height: 1),
            alignment: .bottom
        )
    }
    
    private var scrollView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                ForEach(comments, id: \.id) { comment in
                    CommentView(userName: comment.username, commentString: comment.text)
                        .padding(.bottom, 5)
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            .padding(.top, 10)
            .padding(.bottom, 10)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("GradientDark"), Color("GradientDark")]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    private var commentInputView: some View {
        HStack {
            TextField("", text: $userComment)
                .placeholder(when: userComment.isEmpty) {
                    Text("comment").foregroundColor(.white).opacity(0.4)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color("LightGray").opacity(0.4))
                .border(Color(UIColor.separator))
                .cornerRadius(10)
                
            Button(action: postComment) {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(.green)
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 60)
        .background(Color("GradientDark"))
        .overlay(
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(width: UIScreen.main.bounds.width, height: 1),
            alignment: .top
        )
    }

    // MARK: - Functions
    func fetchComments() {
        apiService.getPostComments(for: postId) { result in
            switch result {
            case .success(let fetchedComments):
                self.comments = fetchedComments
            case .failure(let error):
                print("Error fetching comments: \(error.localizedDescription)")
            }
        }
    }

    func postComment() {
        if !userComment.trimmingCharacters(in: .whitespaces).isEmpty {
            apiService.createComment(postId: postId, username: user.username, text: userComment) { result in
                switch result {
                case .success(let newPostedComment):
                    comments.append(newPostedComment)
                    userComment = ""
                case .failure(let error):
                    print("Error posting comment: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - Preview
struct CommentSection_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "testUsername")
        
        return CommentSectionView<MockAPIService>(apiService: MockAPIService(), postId: 1)
            .environmentObject(testUser)
    }
}
