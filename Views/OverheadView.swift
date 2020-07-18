//
//  OverheadView.swift
//  Elevators
//
//  Created by Peter Larson on 7/13/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI
import Haptica

import UIKit

struct OverheadView: View {
    // Game Data
    @EnvironmentObject var scene: GameScene
    // Bindings
    @Binding var model: LevelModel
    @Binding var showShop: Bool
    @Binding var showDailyGift: Bool
    // State
    @State var hasCollectedDailyGift: Bool
    
    init(model: Binding<LevelModel>, showShop: Binding<Bool>, showDailyGift: Binding<Bool>) {
        self._model = model
        self._showShop = showShop
        self._showDailyGift = showDailyGift
        self._hasCollectedDailyGift = State(initialValue: false)
    }
    
    @State private var scaleTitle = false
    @State private var showContinueLabel = false
    @State private var showContinueButton = false
    @State private var glowContinue = false
    
    var win: some View {
        VStack(spacing: 8) {
            GameText("Level 4 Complete")
                .gameTextSize(40)
                .scaleEffect(scaleTitle ? 1 : 0)
                .padding(.top, UIScreen.main.bounds.height / 4)
            Spacer()
            GameButton {
                Text("Continue")
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 40)
                    .offset(x: !self.showContinueLabel ? -UIScreen.main.bounds.width : 0, y: 0)
                    .scaleEffect(self.showContinueLabel ? 1 : 1.3)
            }
            .padding(.horizontal, 16)
            .foregroundColor(Color(#colorLiteral(red: 0.3351181402, green: 0.9037874513, blue: 0, alpha: 1)))
            .offset(x: !self.showContinueButton ? -UIScreen.main.bounds.width : 0, y: 0)
            .scaleEffect(x: 1, y: self.showContinueButton ? 1 : 0, anchor: .center)
            .font(.custom("Chalkboard SE Bold", size: 24))
            .buttonCornerRadius(16)
            .buttonHighlights(true)
            .buttonPadding(value: 8)
            .opacity(0.8)
            .onButtonPress {
                // Next Level
                // self.model = .demo
                self.scene.reload()
            }
        }.onDisappear {
            self.showContinueButton = false
            self.showContinueLabel = false
            self.scaleTitle = false
            self.glowContinue = false
        }
    }
    
    @State private var showLostTitle = false
    @State private var showSkipButton = false
    @State private var showSkipLabel = false
    @State private var showAdButton = false
    @State private var showAdLabel = false
    @State private var showRetryButton = false
    @State private var showRetryLabel = false
    
    var lost: some View {
        VStack(spacing: 8) {
            GameText("Try Again!")
                .gameTextSize(40)
                .scaleEffect(showLostTitle ? 1 : 0)
            GameButton {
                HStack {
                    Text("Level Reward (0/3)")
                        .foregroundColor(.white)
                }
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 40)
                .offset(x: !self.showSkipLabel ? -UIScreen.main.bounds.width : 0, y: 0)
                .scaleEffect(self.showSkipLabel ? 1 : 1.3)
            }
            .foregroundColor(.red)
            .offset(x: !self.showSkipButton ? -UIScreen.main.bounds.width : 0, y: 0)
            .scaleEffect(x: 1, y: self.showSkipButton ? 1 : 0, anchor: .center)
            .opacity(0.8)
            
            GameButton {
                HStack {
                    Text("Ad Reward")
                    Image("ad")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .offset(y: 3)
                    Text("(0/5)")
                }
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 40)
                .offset(x: !self.showAdLabel ? -UIScreen.main.bounds.width : 0, y: 0)
                .scaleEffect(self.showAdLabel ? 1 : 1.3)
            }
            .foregroundColor(.orange)
            .offset(x: !self.showAdButton ? -UIScreen.main.bounds.width : 0, y: 0)
            .scaleEffect(x: 1, y: self.showAdButton ? 1 : 0, anchor: .center)
            .opacity(0.8)
        }
        .font(.custom("Chalkboard SE Bold", size: 24))
        .buttonCornerRadius(0)
        .buttonHighlights(false)
        .buttonPadding(value: 4)
        .onDisappear {
            self.showLostTitle = false
            self.showSkipButton = false
            self.showSkipLabel = false
            self.showAdButton = false
            self.showAdLabel = false
            self.showRetryButton = false
            self.showRetryLabel = false
        }
    }
    
    @State var showButtons = false
    
    var butttons: some View {
        HStack {
            GameButton {
                Text("🎁")
                    .frame(width: 32)
                    .grayscale(self.hasCollectedDailyGift ? 0.9 : 0)
                    .opacity(self.hasCollectedDailyGift ? 0.5 : 1)
            }
            .foregroundColor(hasCollectedDailyGift ? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)) : .pink)
            .onButtonPress {
                if !self.hasCollectedDailyGift {
                    self.showDailyGift = true
                } else {
                    Haptic.notification(.error).generate()
                }
            }
            
            GameButton {
                Text("▶︎")
                    .brightness(1)
                    .frame(width: 32)
                    .padding(.horizontal, 16)
            }
            .onButtonPress {
                if self.scene.hasLost {
                    self.scene.reload()
                }
                
                self.scene.isPlaying = true
            }
                        
            GameButton {
                Text("🛒")
                    .brightness(1)
                    .frame(width: 32)
            }
            .onButtonPress {
                self.showShop = true
            }
        }
        .offset(x: 0, y: showButtons ? 0 : UIScreen.main.bounds.height / 4)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                
                if self.scene.hasLost {
                    self.lost
                }
                
                Spacer()
                
                self.butttons
            }
            
            if self.scene.hasWon {
                self.win
            }
            
            ConfettiView(isEmitting: scene.hasWon)
        }
        .font(.custom("Futura", size: 32))
        .foregroundColor(Color("theme-1"))
        .onReceive(scene.$isPlaying) { (value) in
            if value {
                print("Player is Playing.")
            }
            
            withAnimation(Animation.linear(duration: 0.3)) {
                self.showButtons = !value
            }
        }
        .onReceive(scene.$hasWon) { (value) in
            if value {
                print("Player Won")
            }
            withAnimation(Animation.linear(duration: 0.3)) {
                self.showContinueButton = value
            }
            
            withAnimation(Animation.interpolatingSpring(stiffness: 100, damping: 10).delay(0.3)) {
                self.showContinueLabel = value
                self.scaleTitle = value
            }
            
            withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                self.glowContinue = value
            }
        }
        .onReceive(scene.$hasLost) { (value) in
            if value {
                print("Player has Lost.")
            }
            // Show Buttons
            
            withAnimation(Animation.linear(duration: 0.3)) {
                self.showSkipButton = value
            }
            
            withAnimation(Animation.linear(duration: 0.3).delay(0.3)) {
                self.showAdButton = value
            }
            
            withAnimation(Animation.linear(duration: 0.3).delay(0.6)) {
                self.showRetryButton = value
            }
            
            // Show Labels
            
            withAnimation(Animation.interpolatingSpring(stiffness: 100, damping: 10).delay(0.3)) {
                self.showSkipLabel = value
                self.showLostTitle = value
            }
            
            withAnimation(Animation.interpolatingSpring(stiffness: 100, damping: 10).delay(0.6)) {
                self.showAdLabel = value
            }
            
            withAnimation(Animation.interpolatingSpring(stiffness: 100, damping: 10).delay(0.9)) {
                self.showRetryLabel = value
            }
        }
        
    }
}

struct OverheadViewiew_Previews: PreviewProvider {
    
    static let scene1 = GameScene(model: .demo), scene2 = GameScene(model: .demo)
    
    
    static var previews: some View {
        Group {
            ZStack {
                GameBackground().onAppear {
//                    scene1.hasWon = true
//                    scene1.isPlaying = true
                }
                OverheadView(model: .constant(.demo), showShop: .constant(false), showDailyGift: .constant(false))
            }
            .environmentObject(scene1)
        }
    }
}
