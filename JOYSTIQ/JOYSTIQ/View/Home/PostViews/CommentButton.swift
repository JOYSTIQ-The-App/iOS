//
//  CommentCount.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 7/6/23.
//

import SwiftUI

struct CommentButton<APIServiceType: APIServiceProtocol>: View {
    var APIService: APIServiceProtocol
    var postId: Int
    @State var commentCount: Int
    @State private var isShowingComments = false
    
    var body: some View {
        
        HStack(spacing: 0) { //for comment counter
            
            Image(systemName: "message")
                .foregroundColor(Color.white.opacity(0.7))
                .imageScale(.small)
                .padding(.trailing, 5)
            
            Text(formatNumber(commentCount))
                .font(.system(size: 14))
                .foregroundColor(.white).opacity(0.7)
            
        } //end Hstack for like button and like count
        .onTapGesture {
            isShowingComments.toggle()
        }
        .sheet(isPresented: $isShowingComments) {
            CommentsView<APIService>(APIService: APIService, postId: postId)
        }
        

        
    } //end body
    
    
    func formatNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    } //end func
    
    
}

struct CommentsView<APIServiceType: APIServiceProtocol>: View {
    @EnvironmentObject var user: User
    var APIService: APIServiceProtocol
    var postId: Int
    @State private var comments: [Comment] = []
    @State private var newComment: String = ""

    var body: some View {
        VStack {
            ScrollView {
                ForEach(comments, id: \.id) { comment in
                    Text(comment.text)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
            }

            HStack {
                TextField("Add a comment...", text: $newComment)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                Button("Post") {
                    if !newComment.trimmingCharacters(in: .whitespaces).isEmpty {
                        postComment()
                    }
                }
                .padding()
            }
            .padding()
        }
        .onAppear(perform: fetchComments)
    }

    func fetchComments() {
        APIService.getPostComments(for: postId) { result in
            switch result {
            case .success(let fetchedComments):
                self.comments = fetchedComments
            case .failure(let error):
                print("Error fetching comments: \(error.localizedDescription)")
            }
        }
    }

    func postComment() {
        APIService.createComment(postId: postId, username: user.username, text: newComment) { result in
            switch result {
            case .success(let newPostedComment):
                // Add the new comment to the local list and clear the text field
                self.comments.append(newPostedComment)
                self.newComment = ""
            case .failure(let error):
                print("Error posting comment: \(error.localizedDescription)")
            }
        }
    }

}


struct CommentButton_Previews: PreviewProvider {
    static var previews: some View {
        CommentButton<MockAPIService>(APIService: MockAPIService(), postId: 1, commentCount: 0).frame(width: UIScreen.main.bounds.width).background(.black)
    }
}
