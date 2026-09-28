//
//  CommentSectionView2.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/4/23.
//

import SwiftUI

import SwiftUI

struct CommentSectionView2: View {
    
    @State private var isCommentSectionVisible = false
    @State private var isDragging = false
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                
                Spacer()
                
                // Handle bar indicating drag interaction
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 40, height: 4)
                    .foregroundColor(Color.gray)
                    .opacity(isCommentSectionVisible ? 1 : 0)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let yOffset = value.translation.height
                                if yOffset > 0 {
                                    isDragging = true
                                    dragOffset = yOffset
                                }
                            }
                            .onEnded { value in
                                let yOffset = value.translation.height
                                isDragging = false
                                if yOffset > geometry.size.height * 0.1 {
                                    isCommentSectionVisible = false
                                }
                                dragOffset = 0
                            }
                    )
                
                ScrollView(.vertical, showsIndicators: false) {
                
        
                    VStack(alignment: .leading) { //VStack for displaying comments
                        
                        ForEach(0..<10) { i in
                            // Comment section content
                            Text("Comment Section Content")
                            
                        }
                        
                    } //END VStack containing comments
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.vertical, 30)
                    
                    
                } //END Scrollview for comments
                .frame(height: geometry.size.height * 0.6)
                .background(Color.white)
                .offset(y: isCommentSectionVisible ? (isDragging ? dragOffset : 0) : geometry.size.height * 0.6)
                .animation(.spring())
         
                
            } //END Main vstack with handle bar and scrollview
            
            
        } //end Geo reader
        .frame(maxHeight: .infinity)
        .background(Color.black.opacity(0.8).ignoresSafeArea())
        .onTapGesture {
            withAnimation {
                isCommentSectionVisible.toggle()
            }
        }
        
        
    } //END Body
}



struct CommentSectionView2_Previews: PreviewProvider {
    static var previews: some View {
        CommentSectionView2()
    }
}
