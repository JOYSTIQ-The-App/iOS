//
//  HeaderView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 5/4/23.
//

import SwiftUI

struct HeaderView: View {
    
    @Binding var showDropDown: Bool
    var onRefreshPress: () -> Void

    
    var body: some View {
        
        HStack(spacing: 0) {  //HStack for Header (noti bell - Logo - Messenger)
            

            /*
            NavigationLink(destination: NotificationTabView().navigationBarTitleDisplayMode(.inline)
                           
               //custom nav title view with image
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Image("NotificationsText")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 26)
                    }
                }) {
                    
                    Image(systemName: "bell.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .padding(.leading, 20)
                        .foregroundColor(Color("LightGray"))
                    
                    
                }
             */
            
            
            Image(systemName: "bell.fill")
                .resizable()
                //.frame(width: 22, height: 22)
                .frame(width: 30, height: 30)
                .padding(.leading, 20)
                .foregroundColor(Color.clear)
      
            
            Spacer()
            
            
            Button(action: {
                
                //open drop down menu
                showDropDown.toggle()
                
            }) {
            
                    Image("JS_Logo2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                                   
            }
            .buttonStyle(NeumorphicButtonStyle2())
            
            Spacer()
            
            //MESSENGER
            /*
            Button(action: {}) {
                Image(systemName: "tray.full.fill")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundColor(Color.clear)
                    .padding(.trailing, 20)
                
            }
             */
            
            //Refresh
            Button(action: {self.onRefreshPress()}) {
                Image(systemName: "arrow.clockwise.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("LightGray"))
                    .padding(.trailing, 20)
                
            }
   
            
        } // END HSTACK with Header
        .frame(height: 65)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("GradientLight"), Color("GradientDark")]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        //bottom green border
        .overlay(
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: UIScreen.main.bounds.width, height: 1),
                alignment: .bottom
                
        )
            
        
    } //end body

}


struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(showDropDown: .constant(false), onRefreshPress: {})
    }
}
