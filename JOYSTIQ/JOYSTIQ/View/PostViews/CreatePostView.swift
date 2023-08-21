//
//  ContentPostView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 4/28/23.
//

import SwiftUI

struct CreatePostView: View {
    
    @Binding var isPresented: Bool
    @State private var selectedPostType = 0
    @State private var videoURL: URL?
    

    var body: some View {
        
        VStack {
            
            VStack(spacing: 1) { //Vstack for x button and create post text
                
                HStack { //Hstack for x button
                    
                    Button(action: {
                        isPresented = false
                        // Dismiss the pop-up window
                        //UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                        
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding()
                        
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isPresented = false                        // Dismiss the pop-up window
                        //UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                        
                        //POST THE VIDEO AND BRING THEM TO HOME
                        
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(width: 95, height: 45)
                                .foregroundColor(.green)
                                .cornerRadius(10)
                                .padding(.trailing, 5)
                            
                            
                            Image(systemName: "chevron.right.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                                .offset(x: 25)
                            
                            
                            Text("Post")
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                                .offset(x: -20)
                            
                            
                            
                        } //END ZSTACK with post button
                        
                        
                    }
                    
                                  
                    
                }//END Hstack with create post and x button
                .padding(.top, 10)
                .padding(.horizontal, 5)
                
                Text("Create a post!")
                    .padding(.top, 20)
                    .font(.system(size: 40))
                    .foregroundColor(.green)
                
            } //END VSTACK for x button and create post text
                  
            HStack(spacing: 0) { //HStack for buttons to switch post type
                            
                Button(action: {
                    selectedPostType = 0
                }, label: {
                    
                    Text("Clip")
                        .foregroundColor(selectedPostType == 0 ? .black : .black)
                        .font(.system(size: 20))
                        .frame(width: UIScreen.main.bounds.width / 2, height: 50)
                        .overlay(Rectangle().frame(width: nil, height: 5, alignment: .bottom).foregroundColor(selectedPostType == 0 ? Color.green : Color("LightGray")), alignment: .bottom)
   
                })
                .background(Color("LightGray"))
                
                //Rectangle()
                //  .foregroundColor(.green)
                //.frame(width: 5, height: 70)
                
                
                Button(action: {
                    selectedPostType = 1
                }, label: {
                    
                    Text("Discussion")
                        .foregroundColor(selectedPostType == 1 ? .black : .black)
                        .font(.system(size: 20))
                        .frame(width: UIScreen.main.bounds.width / 2, height: 50)
                        .overlay(Rectangle().frame(width: nil, height: 5, alignment: .bottom).foregroundColor(selectedPostType == 1 ? Color.green : Color("LightGray")), alignment: .bottom)
                       
                })
                     
                
            } //END Hstack for buttons for post type
            .background(Color("LightGray"))
            .border(Color.gray, width: 1)
            
            if selectedPostType == 0 {
                NewClipPostView()
            } else if selectedPostType == 1 {
                NewDiscPostView()
            }
        
           
           
           

           /*
           Button(action: {
               // Show a video picker to select a video from the user's library
               /*
               let picker = UIImagePickerController()
               picker.sourceType = .savedPhotosAlbum
               picker.mediaTypes = [kUTTypeMovie as String]
               picker.allowsEditing = true
               picker.delegate = self
               UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true, completion: nil)
                */
           }) {
               Text("Select Video")
           }

            */
           

           Spacer()

           
       } //END Main VStack
       .background(Color("Black1"))
   }
}


/*
struct ContentPostView_Previews: PreviewProvider {
    
    @State static var showScreenForever = true
    
    static var previews: some View {
        CreatePostView(isPresented: $showScreenForever)
    }
}
*/
