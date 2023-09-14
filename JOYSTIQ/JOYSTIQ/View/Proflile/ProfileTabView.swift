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
                               
                            HStack(spacing: 10) { //Socials hstack
                                
                                
                                ZStack { //for name plate
                                    
                                    Image("NamePlate4")
                                        .resizable()
                                        .scaledToFit()
                                        
                                    
                                    //Username banner
                                    Text("User12345")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color("LightGray"))
                                    
                                    
                                }//end ZStack for name plate
                                .frame(width: 180, height: 50)
                                .shadow(color: Color.black, radius: 6, x: 2, y: 4)
                                .shadow(color: Color.white.opacity(0.5), radius: 2, x: 0, y: -1)
                                
                                
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
                                
                                
                               
                                
                   
                                Spacer()
                            
                                
                            } //END Socials HStack
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
                            
                            
                            Text("I am the cod goat")
                                .padding(.all, 13)
                                .frame(alignment: .topLeading)
                                .font(.system(size: UIScreen.main.bounds.width * 0.035))
                                .foregroundColor(Color("LightGray"))
                                .background(Color("Black0").opacity(0.4))
                                .cornerRadius(15)
                                .padding(.leading, 10)
                            
                     
                            
                            
                            
                            /*
                            
                            //followers button
                            Button( action: {
                                    //button action here
                                }, label: {
                                    
                                    VStack {
                                        
                                        Text("12")
                                            .font(.system(size: 16))
                                        
                                        Text("followers")
                                            .font(.system(size: 8))
                                        
                                        
                                    }
                                    
                                })
                            .frame(width: 50 , height: 50)
                            .buttonStyle(NeumorphicRectangleButtonStyle2())
                            
                            
                            //following button
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
                                
                             */
                   
                            
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
            .frame(width: 45, height: 45)
            .background(
                Group {
                    if configuration.isPressed {
                        
                        Circle()
                            .fill(Color("GradientDark").opacity(0.8))
                            .overlay(
                                Circle()
                                    .stroke(Color("GradientDark"), lineWidth: 2)
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 3, y: 3)
                            .shadow(color: Color.white.opacity(0.5), radius: 2, x: -1, y: -1)
                        
                    } else {
                        
                        Circle()
                            .fill(Color("GradientLight"))
                            .shadow(color: Color.black.opacity(0.8), radius: 2, x: 2, y: 2)
                            .shadow(color: Color.white.opacity(0.4), radius: 2, x: -1, y: -1)
                            
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            
    }
}

struct NeumorphicButtonStyle2: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .frame(width: 50, height: 50)
            .background(
                Group {
                    if configuration.isPressed {
                        
                        Circle()
                            .fill(Color("GradientDark").opacity(0.8))
                            .overlay(
                                Circle()
                                    .stroke(Color("GradientDark"), lineWidth: 2)
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 3, y: 3)
                            .shadow(color: Color.gray.opacity(0.5), radius: 1, x: -1, y: -1)
                        
                    } else {
                        
                        Circle()
                            .fill(Color("GradientLight").opacity(0.8))
                            .shadow(color: Color.black.opacity(0.4), radius: 1, x: 2, y: 2)
                            .shadow(color: Color("LightGray").opacity(0.4), radius: 1, x: -1, y: -1)
                            
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            
    }
}

struct NeumorphicRectangleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(
                Group {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color("GradientDark").opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color("GradientDark"), lineWidth: 1)
                                    .shadow(color: Color.black.opacity(0.6), radius: 2, x: 2, y: 2)
                                    .shadow(color: Color.white.opacity(0.4), radius: 2, x: -2, y: -2)
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color("GradientLight"))
                            .shadow(color: Color.black.opacity(0.8), radius: 2, x: 2, y: 2)
                            .shadow(color: Color.white.opacity(0.4), radius: 2, x: -1, y: -1)
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct NeumorphicRectangleButtonStyle2: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(
                Group {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color("GradientDark"), lineWidth: 1)
                                    .shadow(color: Color.black.opacity(0.6), radius: 2, x: 2, y: 2)
                                    .shadow(color: Color.white.opacity(0.4), radius: 2, x: -2, y: -2)
                            )
                            //.padding(1)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color("LightGray"))
                            .shadow(color: Color.black.opacity(0.6), radius: 2, x: 2, y: 2)
                            .shadow(color: Color.white.opacity(0.4), radius: 2, x: -1, y: -1)
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView(hideNavBar: .constant(false))
    }
}
