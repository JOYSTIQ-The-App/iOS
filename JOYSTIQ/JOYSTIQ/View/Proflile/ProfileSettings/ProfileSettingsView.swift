//
//  ProfileSettingsView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/10/23.
//

import SwiftUI

struct ProfileSettingsView<APIServiceType: APIServiceProtocol, AuthServiceType: AuthServiceProtocol & ObservableObject>: View {
    
    var apiService: APIServiceType
    @EnvironmentObject var authService: AuthServiceType
    @EnvironmentObject var user: User
    
    @Binding var hideNavBar: Bool
    
    
    var body: some View {
               
        List {
            
            Section(header: Text("Profile")) {
                
                NavigationLink(destination: EditBioView(apiService: apiService)) {
                    
                    HStack { //hstack for bio setting
                        
                        Image(systemName: "person.crop.square.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(.label))
                            .padding(.trailing, 5)
                            
                        Text("Bio")
                        
                    } //end hstack for bio setting
                    
                    
                    
                }
                
                /*
                NavigationLink(destination: EditResumeView(apiService: apiService)) {
                    
                    HStack { //hstack for resume setting
                        
                        Image(systemName: "list.bullet.clipboard.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(.label))
                            .padding(.trailing, 5)
                            
                        Text("Resume")
                        
                    } //end hstack for resume setting
                    
                }
                */
                
                NavigationLink(destination: EditSocialsView(apiService: apiService)) {
                    
                    HStack { //hstack for resume setting
                        
                        Image(systemName: "network")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(.label))
                            .padding(.trailing, 5)
                            
                        Text("Socials")
                        
                    } //end hstack for resume setting
                    
                }
                
            }
            

            Section(header: Text("Profile")) {
                NavigationLink(destination: EditUsernameView(apiService: apiService)) {
                    Text("Change Username")
                }
                
                //NavigationLink(destination: ResetPasswordView()) {
                    //Text("Reset Password")
                //}
                
                Button(action: {
                    
                    Task {
                        await authService.signOutLocally()
                        await authService.fetchCurrentAuthSession()
                    }
                    
                }) {
                    Text("Logout")
                        .foregroundColor(.red)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Settings")
        .onAppear{
            hideNavBar = true
        } //end list
        .preferredColorScheme(.dark) // Force dark mode
    }
}

//struct ResetPasswordView: View {
  //  var body: some View {
   //     Text("Reset Password View")
   // }
//}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "Apical")
        
        return ProfileSettingsView<MockAPIService, MockAuthService>(apiService: MockAPIService(), hideNavBar: .constant(true))
            .environmentObject(testUser)
            .environmentObject(MockAuthService())
    }
}
