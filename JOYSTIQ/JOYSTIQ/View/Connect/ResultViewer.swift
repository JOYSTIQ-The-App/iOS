//
//  ResultViewer.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 10/10/23.
//

import SwiftUI

struct ResultViewer<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    var apiService: APIServiceType
    let usernames: [String]
    @EnvironmentObject var user: User
    
    // MARK: - Body
    var body: some View {
        
        VStack {
            
            ScrollView(.vertical) {
                
                //no matching results
                if usernames.isEmpty {
                    Text("no results")
                        .foregroundColor(Color.gray)
                }
                
                //found results, display them
                else {
                    
                
                    ForEach(usernames, id: \.self) { username in
                        
                        
                        NavigationLink(destination: OtherProfileView(apiService: apiService, profileUsername: username, showCommentSection: .constant(false)).navigationBarTitleDisplayMode(.automatic).environmentObject(PlayerManager())
                         ) {
                         
                        
                        HStack {
                            
                            Text(username)
                                .padding(8)
                                .foregroundColor(Color("LightGray"))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray.opacity(0.6))
                            
                            
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.85)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .background(Color.gray.opacity(0.08))
                        .cornerRadius(10)
                        
                        
                        } //end nav link
  
                    } //end for each
                    
                } //end else
                
            } //end scrollview
            
            
            Spacer()
        } //end main vstack
    } //end body
}




// MARK: - Preview
struct ResultViewer_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "Apical")
        
        return ResultViewer<MockAPIService>(apiService: MockAPIService(), usernames: ["jane"])
            .environmentObject(testUser)
    }
}
