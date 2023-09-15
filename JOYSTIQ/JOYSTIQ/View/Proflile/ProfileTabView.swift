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

    @State private var profileImage: UIImage? // State to hold the avatar image
    
    var body: some View {
        
        NavigationView { //start nav view
            
            ScrollView (.vertical, showsIndicators: true) {
                
                VStack { //Main VStack
                    
                    
                    VStack(spacing: 0) { //VStack for [avatar] / [bio / username overlay]
                        
                        ZStack { //ZStack for Z[environment / self options] and avatar image
                            
                            //avatar image
                            if let image = profileImage {
                                
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.width * 0.7)
                                    .padding(.top, 20)
                                    .zIndex(1)
                                
                                
                            }
                            else {
                                Text("No image selected")
                                    .frame(width: 100, height: 50)
                                    .zIndex(1)
                            }
                            
                            ZStack(alignment: .bottom) { //for avatar background and own profile settings
                                
                                
                                Image("default3")
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width, height: 350)
                                    .edgesIgnoringSafeArea(.top)
                                    .aspectRatio(contentMode: .fill)
                                    .shadow(color: Color.black, radius: 6, x: 0, y: 4)
                                
                                
           

                                
                                HStack { //for own profile options
                                    
                                    
                                    NavigationLink(destination: WardrobeView(hideNavBar: $hideNavBar, profileImage: $profileImage).navigationBarTitleDisplayMode(.inline)
                                                   
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
                            .zIndex(0)
                            
                        } //end ZStack for [environment / self options] and avatar image
                        
                        
                        
                        
                            
                        VStack(alignment: .leading, spacing: 0) { //VStack for Bio and Social/resume buttons
                               
                            HStack(spacing: 0) { //Socials hstack
                                
                                
                                
                                ZStack { //for name plate
                                    
                                    Image("NamePlate5")
                                        .resizable()
                                        .scaledToFit()
                                        
                                    
                                    //Username banner
                                    Text("User123456789")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color("LightGray"))
                                        .padding(.trailing, 40)
                                    
                                    
                                }//end ZStack for name plate
                                .frame(height: 50)
                                .shadow(color: Color.black, radius: 6, x: 2, y: 4)
                                .shadow(color: Color.white.opacity(0.5), radius: 2, x: 0, y: -1)
                                
                                //Spacer()
                                
                                /*
                                //followers button
                                Button( action: {
                                        //button action here
                                    }, label: {
                                        
                                        HStack(spacing: 5) {
                                            
                                            Text("1200")
                                                .font(.system(size: 14))
                                                .bold()
                                                
                                            
                                            Text("followers")
                                                .font(.system(size: 10))
                                            
                                            
                                        }
                                        
                                    })
                                .frame(height: 40)
                                .buttonStyle(NeumorphicRectangleButtonStyle2())
                                //.padding(.trailing, 10)
                                */
                                                  
                                Spacer()
                                
                                
                                Button( action: {
                                        //button action here
            
                                    
                                    }, label: {
                                        //PAGE CONTENT
                                        
                                        Image(systemName: "network")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color("LightGray"))
                                        
                                    })
                                    .buttonStyle(NeumorphicButtonStyle())
                                    .padding(.trailing, 10)
                                

                                
                                // Resume button
                                Button( action: {
                                        //button action here
                                    }, label: {
                                        
                                        Image(systemName: "list.bullet.clipboard.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color("LightGray"))
                                        
                                    })
                                .buttonStyle(NeumorphicButtonStyle())
                                .padding(.trailing, 10)
                                
                               
                                
                   
                                
                            
                                
                            } //END Socials HStack
                            .frame(width: UIScreen.main.bounds.width)
                            .padding(.top, 10)
                            
                            
                            Text("I am the cod goat twitch.tv/codgoat \nFollow the stream")
                                .padding(.all, 13)
                                .background(Color("Black0").opacity(0.3))
                                .cornerRadius(15, corners: [.topRight, .bottomRight])
                                .frame(
                                    minWidth: UIScreen.main.bounds.width * 0.3,
                                    maxWidth: UIScreen.main.bounds.width * 0.7, // Set the maximum width here
                                    alignment: .topLeading
                                )
                                .font(.system(size: UIScreen.main.bounds.width * 0.035))
                                .foregroundColor(Color("LightGray"))
                                
                          
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




struct ProfileTabView_Previews: PreviewProvider {
    
    let blankImage = UIImage()
    
    
    static var previews: some View {
        ProfileTabView(hideNavBar: .constant(false))
    }
}
