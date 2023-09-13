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
                        
                        
                            
                        VStack(alignment: .leading) { //VStack for Bio and Social/resume buttons
                               
                            HStack(spacing: 30) { //Socials hstack
                                
                                
                                //Username banner
                                Text("User12345")
                                    .frame(width: 160, height: 40)
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                    .background(Color("ColorGreen"))
                                    .cornerRadius(15)

                                
                                
                                
                                Button( action: {
                                        //button action here
            
                                    
                                    }, label: {
                                        //PAGE CONTENT
                                        
                                        Image(systemName: "network")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color.black)
                                        
                                    })
                                    .buttonStyle(NeumorphicButtonStyle())
                                

                                
                                Button( action: {
                                        //button action here
                                    }, label: {
                                        
                                        Image(systemName: "list.bullet.clipboard.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color.green)
                                        
                                    })
                                
                                Spacer()
                                
                                
                                
                            } //END Socials HStack
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
                            
                            
                            Text("I am the cod goat \nFollow me on twitch.tv/codGoat \n100T content creator")
                                .padding(.all, 13)
                                .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.09, alignment: .topLeading)
                                .font(.system(size: UIScreen.main.bounds.width * 0.035))
                                .foregroundColor(Color("LightGray"))
                                .background(Color("Black0").opacity(0.4))
                                .cornerRadius(15)
                                .padding(.leading, 10)
                                
                   
                            
                        } //END bio vstack
                            
           
                        
                        
                    }
                    
                    
                    //Accolade banner
                    AccoladeBanner()
                    
                    /*
                    //Content filter
                    GameDropDownMenu()
                        .padding(15)
                        .frame(width: UIScreen.main.bounds.width)
                        .offset(x: -120)
                    */
                    
                    Spacer()
                        .frame(height: 300)
                  
               

                    
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



struct NeumorphicButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 50, height: 50)
            .background(
                Group {
                    if configuration.isPressed {
                        Circle()
                            .fill(Color.gray)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 4)
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 6, x: 6, y: 6)
                            .shadow(color: Color.white.opacity(0.7), radius: 6, x: -6, y: -6)
                    } else {
                        Circle()
                            .fill(Color.gray)
                            .shadow(color: Color.black.opacity(0.4), radius: 2, x: 2, y: 2)
                            .shadow(color: Color.white.opacity(0.5), radius: 2, x: -2, y: -2)
                            
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            
    }
}



struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView(hideNavBar: .constant(false))
    }
}
