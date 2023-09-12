//
//  ProfileTabView.swift
//  JOYSTIQ
//
//  Created by cs dev on 4/10/23.
//

import SwiftUI

struct ProfileTabView: View {
    
    //handles logged state
    @EnvironmentObject var authService: AuthService
    
    @Binding var hideNavBar: Bool
    
    var body: some View {
        
        NavigationView { //start nav view
            
            ScrollView (.vertical, showsIndicators: true) {
                
                VStack { //Main VStack
                    
                    
                    VStack(spacing: 0) { //VStack for [avatar] / [bio / username overlay]
                        
                        
                        
                        ZStack(alignment: .bottom) { //for avatar background and own profile settings
                            
                            
                            Image("default3")
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width, height: 350)
                                .edgesIgnoringSafeArea(.top)
                                .aspectRatio(contentMode: .fill)
                            

                            
                            HStack { //for own profile options
                                
                                
                                NavigationLink(destination: WardrobeView(hideNavBar: $hideNavBar).navigationBarTitleDisplayMode(.inline)
                                               
                                   //custom nav title view with image
                                    .toolbar {
                                        ToolbarItem(placement: .principal) {
                                            
                                            Text("Wardrobe")
                                            
                                        }
                                    }) {
                                        
                                        ZStack { //for wardrobe button

                                            Image(systemName: "square")
                                                .resizable()
                                                .frame(width: 35, height: 35)
                                                .foregroundColor(Color("LightGray"))
                                            
                                            
                                            Image(systemName: "tshirt.fill")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(Color("LightGray"))
                                            
                                        } //end zstack for wardrobe button
           
                                    }
                                
           
                                Spacer()
                                
                                          
                                NavigationLink(destination: ProfileSettingsView(hideNavBar: $hideNavBar).navigationBarTitleDisplayMode(.inline)
                                               
                                   //custom nav title view with image
                                    .toolbar {
                                        ToolbarItem(placement: .principal) {
                                            
                                            Text("Settings")
                                                .font(.system(size: 18))
                                                .foregroundColor(Color(.label))
                                            
                                        }
                                    }) {
                                        
                                        ZStack { //for settings button

                                            Image(systemName: "square")
                                                .resizable()
                                                .frame(width: 35, height: 35)
                                                .foregroundColor(Color("LightGray"))
                                            
                                            
                                            Image(systemName: "gearshape.fill")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(Color("LightGray"))
                                            
                                        } //end zstack for settings button
                                        
                                        
                                    }
                                
                            
                                
                            }//end hstack for own profile settings / wardrobe
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                            .padding(.bottom, 15)

              
                            
                        } //end ZStack for avatar background and own profile settings
                        
                        
                            
                        VStack { //VStack for Bio and Social/resume buttons
                               
                            HStack(spacing: 20) { //Socials hstack
                                
                                Button( action: {
                                        //button action here
            
                                    
                                    }, label: {
                                        //PAGE CONTENT
                                        
                                        Image(systemName: "network")
                                            .font(.system(size: 33))
                                            .foregroundColor(.green)
                                        
                                    })
                                
                                
                                //Username banner
                                Text("User12345")
                                    .frame(width: 200, height: 40)
                                    .font(.system(size: 22))
                                    .foregroundColor(.black)
                                    .background(Color("ColorGreen"))
                                    .cornerRadius(20)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 10)
                                
                                
                                
                                Button( action: {
                                        //button action here
                                    }, label: {
                                        
                                        Image(systemName: "list.bullet.clipboard.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(.green)
                                        
                                    })
                                
                                
                            } //END Socials HStack
                            
                            
                            Text("I am the cod goat \nFollow me on twitch.tv/codGoat \n100T content creator")
                                .padding()
                                .frame(width: UIScreen.main.bounds.width - 30, height: 90, alignment: .topLeading)
                                .font(.system(size: 16))
                                .foregroundColor(Color("LightGray"))
                                .background(Color("Black0"))
                                .cornerRadius(15)
                                
                   
                            
                        } //END bio vstack
                            
           
                        
                        
                    }
                    
                    
                    //Accolade banner
                    AccoladeBanner()
                    
                    //Content filter
                    GameDropDownMenu()
                        .padding(15)
                        .frame(width: UIScreen.main.bounds.width)
                        .offset(x: -120)
                    
                    Spacer()
                        .frame(height: 200)
                  
               

                    
                }//End Main VStack
                //.background(Color("Black1"))
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("GradientDark3"), Color("GradientLight")]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )

                
                
            } //End Scroll View
            .edgesIgnoringSafeArea(.top)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear{hideNavBar = false}
            
            
        }
        .accentColor(Color(.label))
        
       
        
    } //END BODY
}


struct GameDropDownMenu: View {
    
    let options = ["VALORANT", "Call of Duty", "Halo", "Apex"]
    @State private var selectedOption = "VALORANT"
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    self.selectedOption = option
                }) {
                    Text(option)
                }
            }
        } label: {
            
            HStack() {
                
                Image(systemName: "gamecontroller.fill")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .frame(width: 20, height: 20)
                
                Text(selectedOption)
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        }
        .frame(width: UIScreen.main.bounds.width / 3, height: 40)
        .padding(.leading, 10)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.leading, 20)
        
    }
}








struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView(hideNavBar: .constant(false))
    }
}
