//
//  GameButton.swift
//  Elevators
//
//  Created by Peter Larson on 5/23/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct GameButton<Content>: View where Content: View {
    
    let content: () -> Content
    
    @State private var isPressing = false
    
    @Environment(\.buttonPadding) var buttonPadding
    @Environment(\.buttonScales) var buttonScales
    @Environment(\.buttonHandler) var buttonHandler
    @Environment(\.buttonCornerRadius) var buttonCornerRadius
    
    @inlinable public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var gesture: some Gesture {
        LongPressGesture(minimumDuration: 0)
            .onEnded { (value) in
                self.isPressing.toggle()
                AppDelegate.impact.impactOccurred()
        }
        .sequenced(before: DragGesture(minimumDistance: 0.0, coordinateSpace: .local)
            .onEnded({ (action) in
                self.isPressing.toggle()
                self.buttonHandler?()
            }))
    }
    
    var background: some View {
        ZStack {
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .brightness(-0.25)
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .padding(.bottom, isPressing ? 0 : buttonPadding)
        }
    }
    
    var body: some View {
        content()
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .padding(.bottom, buttonPadding)
            .offset(y: !isPressing ? 0 : buttonPadding)
            .background(background)
            .gesture(gesture)
            .scaleEffect(isPressing && buttonScales ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.2))
    }
}

struct WideGameButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            VStack(spacing: 8) {
                GameButton() {
                    VStack {
                        Text("Play Again")
                        Text("Poop")
                    }
                    .foregroundColor(.white)
                }                .foregroundColor(.red)
                
                GameButton {
                    Text("Play Again")
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .doesButtonScale(enabled: false)
                .buttonCornerRadius(0)
                .buttonPadding(value: 5.0)
                .foregroundColor(.red)
                
                GameButton {
                    Text("👉")
                }
                .foregroundColor(.white)
                .buttonPadding(value: 5.0)
                
            }
            .font(.custom("Futura Medium", size: 32))
        }
    }
}