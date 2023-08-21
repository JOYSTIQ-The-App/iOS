//
//  ConnectTabView.swift
//  JOYSTIQ
//
//  Created by cs dev on 4/10/23.
//

import SwiftUI

struct ConnectTabView: View {
    
    @State private var searchText: String = "search"
    @FocusState private var isEditing
        
    var body: some View {
        VStack {
            
              ZStack(alignment: .leading) { //Search bar ZStack
                               
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color("ColorGreen"))
                    .padding(.leading, 15)
                    .scaledToFit()
                    .scaleEffect(1.5)
                
                TextField("", text: $searchText)
                    .padding(.vertical, 8)
                    .padding(.leading, 50)
                    //input text color
                    .background(Color.gray.opacity(0.2))
                    .accentColor(.green)
                    .foregroundColor(Color("LightGray"))
                    .font(.system(size: 20))
                  
                    .onTapGesture {
                        
                        isEditing = true
                        
                        if searchText == "search" {
                            searchText = ""
                        }
                    }
                  
                    .onSubmit {
                        isEditing = false
                    }
                  
                    .focused($isEditing)
                  
                  if searchText.isEmpty {
                      Text(searchText)
                          .foregroundColor(Color("LightGray"))
                          .padding(.leading, 55)
                          .font(.system(size: 25))
                  }
                
            } //END Search bar ZStack
            .cornerRadius(360)
            .padding(.horizontal, 20)
            .onTapGesture {
                isEditing = false
            }
            .padding(.vertical, 30)
            
            
            Text("Connect")
                .foregroundColor(Color("LightGray"))
                .padding(.vertical, 7)
                .frame(width: 130)
                .background(Color("Black3"))
                .cornerRadius(20)
                .font(.system(size: 25))
            
            
            
        
            HStack { //for gamer and group button
                
                
                Button( action: {
                        //button action here
                    }, label: {
                        //PAGE CONTENT
                        VStack {
                            
                            Image(systemName: "person.fill")
                                .foregroundColor(Color("ColorGreen"))
                                .frame(width: 70, height: 50)
                                .font(.system(size: 80))
                                
                            
                            
                            Text("Gamer")
                                .foregroundColor(Color("ColorJSGreen"))
                                .font(.system(size: 26))
                                .offset(y: 15)
                        }
                        
                    })
                .frame(width: 160, height: 160)
                .background(Color("Black3"))
                .cornerRadius(40)
                .padding(.trailing, 20)
                
  
                
                Button( action: {
                        //button action here
                    }, label: {
                        //PAGE CONTENT
                        VStack {
                            
                            Image(systemName: "person.3.fill")
                                .foregroundColor(Color("ColorGreen"))
                                .frame(width: 100, height: 100)
                                .font(.system(size: 60))
                                
                            
                            
                            Text("Group")
                                .foregroundColor(Color("ColorJSGreen"))
                                .font(.system(size: 26))
                                .offset(y: -10)
                                
                        }
                        
                    })
                .frame(width: 160, height: 160)
                .background(Color("Black3"))
                .cornerRadius(40)
                
                
          
                
            } //END Hstack with gamer and group buttton
            .padding(.top, 20)
            
            
            
            Text("Recommended Gamers")
                .foregroundColor(Color("LightGray"))
                .frame(width: UIScreen.main.bounds.width - 60)
                .padding(.vertical, 7)
                .background(Color("Black3"))
                .cornerRadius(20)
                .font(.system(size: 25))
                .padding(.top, 40)
                .padding(.bottom, 10)
            
            //Reccomended Gamers Scroll view
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(spacing: 20) {
                    
                    ForEach(0..<10) { index in
                        
                        ZStack {
                            
                            Rectangle()
                                .fill(Color("Black3"))
                                .frame(width: 160, height: 200)
                                .cornerRadius(40)
                            
                            Rectangle()
                                .fill(Color("ColorGreen"))
                                .frame(width: 160, height: 50)
                                .cornerRadius(40)
                                .offset(y: 80)
                            
                            
                            Image(systemName: index == 1 ? "figure.wave" : "figure.stand")
                                .frame(width: 50, height: 120)
                                .font(.system(size: 100))
                                .foregroundColor(.gray)
                                .accentColor(.white)
                                .offset(y: -10)
                            
                            
                            Text("UserName")
                                .foregroundColor(.black)
                                .font(.system(size: 26))
                                .offset(y: 80)
                            
                            //turn into a flip button
                            /*
                            ZStack {
                                
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.system(size: 22))
                                    .foregroundColor(.blue)
                                    .offset(x: 55, y: -70)
                                    .zIndex(2)
                                    .onTapGesture {
                                        //flip the panel
                                    }
                                
                                Circle()
                                    .frame(width: 30, height: 30)
                                    
                                    .background(Circle().fill(Color.black))
                                    .offset(x: 55, y: -70)
                                    .zIndex(1)
                                
                            } //END Zstack with flip button
                        */
        
                            
                        } // END ZStack with reccomendation card
                        
                        
                    } //END Hstack with reccommended users
                    
                    //See more reccomended gamers button
                    Button( action: {
                            //button action here
                        }, label: {
                            //PAGE CONTENT
                            
                            Image(systemName: "plus.app.fill")
                                .frame(width: 60, height: 60)
                                .font(.system(size: 60))
                                .foregroundColor(Color("ColorGreen"))
                                .accentColor(.white)
                                .padding(.leading, 20)
                                .padding(.trailing, 10)
                            
                    })
                    
       
                } //End Hstack containing individual gamers
                .frame(height: 230)
                .padding(.leading, 20)
                .padding(.trailing, 50)
                
            } //End ScrollView for reccomended gamers
            
            
            
            
            Spacer()
            
            
            
        } // END MAIN VSTACK
        .background(Color("Black0"))
        //frame(
        
        
        
    }
    
}

struct ConnectTabView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectTabView()
    }
}
