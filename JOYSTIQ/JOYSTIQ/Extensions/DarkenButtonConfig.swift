//
//  ButtonTest.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 8/29/23.
//

import SwiftUI

struct DarkeningButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        DarkeningButton(configuration: configuration)
    }
}

struct DarkeningButton: View {
    
    @GestureState private var isPressed = false

    let configuration: ButtonStyle.Configuration

    var body: some View {
        configuration.label
            .foregroundColor(isPressed ? Color("Black3") : Color.black)
            .padding()
            .padding(.horizontal, 10)
            .background(isPressed ? Color("AccentColor2") : Color("AccentColor"))
            .cornerRadius(10)
            //.animation(.easeInOut(duration: 0.2))
            .gesture(
                LongPressGesture()
                    .updating($isPressed) { value, state, _ in
                        state = value
                    }
            )
    }
}

struct ContentView: View {
    var body: some View {
        Button(action: {
            // Button action here
        }) {
            Text("Press Me!")
        }
        .buttonStyle(DarkeningButtonStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
