//
//  NeumorphicButtons.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/14/23.
//

import SwiftUI

struct NeumorphicButtons: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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

struct NeumorphicButtons_Previews: PreviewProvider {
    static var previews: some View {
        NeumorphicButtons()
    }
}
