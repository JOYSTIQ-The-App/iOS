//
//  ResumeView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/27/23.
//

import SwiftUI

struct ResumeView: View {
    
    var resume: String
    @Binding var showResume: Bool
    
    var body: some View {
        
        VStack(spacing: 0) { //VStack for main container
            VStack {
                Image(systemName: "list.bullet.clipboard.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color("LightGray"))
                
                Text(resume)
                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                    .foregroundColor(Color("LightGray"))
        
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
            
            Spacer()
            
            //Close button
            Button(action: {
                
                showResume.toggle()
                
            }, label: {
                
                Text("Close")
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: UIScreen.main.bounds.width * 0.20, height: 40)
                    .background(.gray.opacity(0.8))
                    .cornerRadius(10)
            })
            .contentShape(Rectangle()) // This makes the entire frame tappable
            .padding(.bottom, 20)
            
            
            
            
        } //END main vstack container
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.3)
        .background(.black)
        .cornerRadius(10)
        .shadow(color: Color.green.opacity(0.5), radius: 5, x: 2, y: 2)
        .shadow(color: Color.green.opacity(0.5), radius: 5, x: -2, y: -2)
        .padding(.bottom, UIScreen.main.bounds.height * 0.2)
        
    } //end body
    
}

struct ResumeView_Previews: PreviewProvider {
    static var previews: some View {
        ResumeView(resume: "This is my resume. Pretty impressive right?", showResume: .constant(true))
    }
}
