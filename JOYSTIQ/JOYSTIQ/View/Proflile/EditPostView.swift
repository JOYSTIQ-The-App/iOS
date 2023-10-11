//
//  EditPostView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/28/23.
//

import Foundation
import SwiftUI

struct EditPostView<APIServiceType: APIServiceProtocol>: View {
    var apiService: APIServiceProtocol
    @Binding var post: Post?
    @EnvironmentObject var user: User
    
    @State private var editedBody: String = ""
    @State private var hasChanged: Bool = false
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Edit Post")
                .font(.headline)
                .padding(.top)
            
            TextField("Edit Post", text: $editedBody, onEditingChanged: { _ in
                hasChanged = (post?.body != editedBody)
            })
                .multilineTextAlignment(.center)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                .padding()

            if hasChanged {
                Button("Save Changes") {
                    if let postID = post?.id {
                        apiService.updateUserPost(email: user.email, postId: postID, bodyText: editedBody) { result in
                            switch result {
                            case .success():
                                post?.body = editedBody
                                self.presentationMode.wrappedValue.dismiss()
                            case .failure(let error):
                                print("Failed to update post: \(error.localizedDescription)")
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            // Update editedBody when the view appears
            editedBody = post?.body ?? ""
        }
    }
}


// MARK: - Preview
struct EditPostView_Previews: PreviewProvider {

    static var previews: some View {
        let testPost = Post(id: 1, user_id: 1, s3_key: S3Key(String: "someKey1", Valid: false), media: "none", game: "GameA", body: "Global feed post 1", status: "live", likes: 7, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 7)
        
        return PreviewWrapper(post: testPost)
    }
}

struct PreviewWrapper: View {
    @State var post: Post?
    
    var body: some View {
        EditPostView<MockAPIService>(apiService: MockAPIService(), post: $post)
    }
}
