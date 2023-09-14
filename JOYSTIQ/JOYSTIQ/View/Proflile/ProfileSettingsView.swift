//
//  ProfileSettingsView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/10/23.
//

import SwiftUI

struct ProfileSettingsView: View {
    
    @Binding var hideNavBar: Bool
    //handles logged state
    @EnvironmentObject var authService: AuthService
    
    
    var body: some View {
               
        List {
            
            Section(header: Text("Profile")) {
                
                NavigationLink(destination: EditBioView()) {
                    
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
                
                NavigationLink(destination: EditResumeView()) {
                    
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
                
                NavigationLink(destination: EditSocialsView()) {
                    
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
                NavigationLink(destination: ChangeUsernameView()) {
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
        }
        
    }
}

struct EditBioView: View {
    var body: some View {
        Text("Edit Bio View")
    }
}

struct EditResumeView: View {
    var body: some View {
        Text("Edit Resume View")
    }
}

struct EditSocialsView: View {
    var body: some View {
        Text("Edit Socials View")
    }
}

struct ChangeUsernameView: View {
    var body: some View {
        Text("Change Username View")
    }
}

//struct ResetPasswordView: View {
  //  var body: some View {
   //     Text("Reset Password View")
   // }
//}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView(hideNavBar: .constant(true))
    }
}
