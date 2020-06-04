//
//  UnlockElevatorView.swift
//  Elevators
//
//  Created by Peter Larson on 5/28/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}

struct UnlockElevatorView: View {
    
    let completion = 5
    
    @State var frame = 0
    @State var open = false
    @State var attempts = 0
    @State var glowAnimation = false
    
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            GameBackground()
            RadialStripes()
                .opacity(open ? 1 : 0)
            
            Group {
                Image(uiImage: Graphics.elevatorBackground(style: .demo))
                    .resizable()
                VStack {
                    Image("firefighter-idle-1")
                        .resizable()
                        .opacity(open ? 1 : 0)
                        .padding(.top, UIScreen.main.bounds.width / 4 * 0.4)
                }
                Image(uiImage: Graphics.elevatorOverlay(style: .demo, percent: CGFloat(frame) / 20.0))
                    .resizable()
            }
            .scaledToFit()
            .frame(width: open ? UIScreen.main.bounds.width / 3:UIScreen.main.bounds.width / 4)
            .modifier(Shake(animatableData: CGFloat(self.attempts)))
            .onTapGesture {
                if self.attempts < self.completion {
                    withAnimation(.spring()) {
                        self.attempts += 1
                        AppDelegate.impact.impactOccurred(intensity: CGFloat(self.attempts) / CGFloat(self.completion))
                    }
                } else if !self.open {
                    withAnimation(.spring()) {
                        self.open = true
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: GameScene.doorSpeed / 20.0, repeats: true) { (timer) in
                        if self.frame <= 20 {
                            self.frame += 1
                        } else {
                            timer.invalidate()
                        }
                    }
                }
            }
            
            if !open {
                VStack {
                    Text("Tap to Open")
                        .opacity(self.glowAnimation ? 1 : 0.8)
                        .animation(Animation.easeInOut.repeatForever(autoreverses: true))
                }
                .padding(.bottom, UIScreen.main.bounds.height / 4)
                .onAppear {
                    self.glowAnimation = true
                }
            }
            
            if open {
                VStack {
                    Spacer()
                    GameButton {
                        Text("Claim")
                            .foregroundColor(.white)
                    }
                    .foregroundColor(Color("Coin"))
                    .onButtonPress {
                        self.isShowing = false
                    }
                }
                .transition(.move(edge: .bottom))
                
                VStack {
                    Text("Bröther")
                    Text("May I have oats")
                }
                .padding(.bottom, UIScreen.main.bounds.height / 3)
                .padding(.bottom, 16)
                .foregroundColor(.white)
                .transition(.move(edge: .top))
            }
        }
        .font(.custom("Futura Bold", size: 24))
        .foregroundColor(.white)
        .transition(.opacity)
    }
}

struct UnlockElevatorView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            UnlockElevatorView(isShowing: .constant(false))
        }
        .statusBar(hidden: true)
        .previewDevice("iPhone 11")
    }
}
