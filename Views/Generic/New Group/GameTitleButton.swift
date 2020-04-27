//
//  GameButton.swift
//  Elevators
//
//  Created by Peter Larson on 4/6/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI


struct GameTitleButton: View {
    
    @Binding var pressed: Bool
    @State private var text: String
    @State private var press: Bool = false
    
    init(_ text: String = "button", pressed: Binding<Bool>) {
        self._text = State(initialValue: text)
        self._pressed = pressed
    }
    
    func action() {
        self.pressed.toggle()
    }
    
    @State private var animating = false
    
    var gesture: some Gesture {
        LongPressGesture(minimumDuration: 0)
            .onEnded { (value) in
                self.press.toggle()
                self.action()
        }.sequenced(before: TapGesture()
            .onEnded({ (action) in
                self.press.toggle()
            }))
    }
    
    var body: some View {
        ZStack {
            Capsule()
                .shadow(color: Color.black.opacity(0.15), radius: 0, x: 0, y: 10)
                .overlay(
                    Capsule()
                        .stroke(lineWidth: 5)
                        .foregroundColor(.white)
                )
            Text(self.text.uppercased())
                .kerning(2.5)
                .autocapitalization(.allCharacters)
                .foregroundColor(.white)
                .padding(5)
        }
        .font(.custom("Belligan", size: 32))
        .gesture(self.gesture)
        .scaleEffect(self.press ? 0.8 : 1)
        .animation(.easeOut(duration: 0.2))
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                if self.press {
                    return
                }
                self.animating.toggle()
            }
        }
        
    }
}

struct GameTitleButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
            GameTitleButton("Play", pressed: .constant(false))
                .foregroundColor(.green)
                .frame(width: 150, height: 60)
        }.edgesIgnoringSafeArea(.all)
    }
}
