//
//  ProfileSettingsView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/10/23.
//

import SwiftUI

struct ProfileSettingsView<APIServiceType: APIServiceProtocol>: View {
    
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var user: User
    var APIService: APIServiceType
    
    @Binding var hideNavBar: Bool
    
    
    var body: some View {
               
        List {
            
            Section(header: Text("Profile")) {
                
                NavigationLink(destination: EditBioView(APIService: APIService)) {
                    
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
                NavigationLink(destination: EditResumeView(APIService: APIService)) {
                    
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
                
                NavigationLink(destination: EditSocialsView(APIService: APIService)) {
                    
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
                NavigationLink(destination: EditUsernameView(APIService: APIService)) {
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
        
        return ProfileSettingsView<MockAPIService>(APIService: MockAPIService(), hideNavBar: .constant(true))
            .environmentObject(testUser)
    }
}
