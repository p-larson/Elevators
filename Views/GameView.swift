//
//  GameView.swift
//  Elevators
//
//  Created by Peter Larson on 7/16/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI
import Haptica

struct GameView: View {
    // *** State ***
    @State fileprivate var showShop = false
    @State fileprivate var showDailyGift = false
    @State fileprivate var showDeveloper = false
    @State fileprivate var isLoading = true
    @State fileprivate var canCollectGift = true
    @State fileprivate var model: LevelModel
    // *** Observables ***
    @ObservedObject private(set) public var scene: GameScene
    // Init
    public init(level: LevelModel) {
        self._model = State(initialValue: level)
        self._scene = ObservedObject(initialValue: GameScene(model: level))
    }
    // *** Main View ***
    var body: some View {
        ZStack {
            GameBackground()
                .brightness(hideGame ? -0.75 : 0)
            ZStack {
                GameContainerView()
                    .edgesIgnoringSafeArea(.all)
                    .disabled(!scene.isLoaded)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    if scene.hasLost {
                        lost
                    }
                    
                    Spacer()
                    menu
                }
                
                if scene.hasWon {
                    ConfettiView(isEmitting: scene.hasWon)
                    win
                }
                
                if showShop {
                    ShopView(isShowing: $showShop)
                }
                
                if showDailyGift {
                    DailyGiftView(isShowing: $showDailyGift, hasCollectedDailyGift: $canCollectGift)
                }
            }
            .opacity(hideGame ? 0 : 1)
            
            levelDetail
            
            CoinCounterView()
        }
        .environmentObject(scene)
        .statusBar(hidden: true)
        .foregroundColor(Color("theme-1"))
        .font(.custom("Chalkboard SE Bold", size: 24))
        .onReceive(scene.$isLoaded, perform: willLoad(loaded:))
        .onReceive(scene.$isPlaying, perform: onPlayingChange(value:))
        .onReceive(scene.$hasWon, perform: onWin(value:))
        .onReceive(scene.$hasLost, perform: onLost(value:))
    }
    
    // *** State Animation ***
    // Win
    @State fileprivate var scaleWinTitle = false
    @State fileprivate var showContinueLabel = false
    @State fileprivate var showContinueButton = false
    @State fileprivate var glowContinue = false
    // Lost
    @State fileprivate var showLostTitle = false
    @State fileprivate var showSkipButton = false
    @State fileprivate var showSkipLabel = false
    @State fileprivate var showAdButton = false
    @State fileprivate var showAdLabel = false
    @State fileprivate var showRetryButton = false
    @State fileprivate var showRetryLabel = false
    // Menu
    @State fileprivate var showMenu = false
    // Load Screen
    @State fileprivate var showLevelTitle = false
    @State fileprivate var hideGame = true
}

// *** Sub Views ***

// Win View
fileprivate extension GameView {
    var win: some View {
        VStack(spacing: 8) {
            GameText("Level 4 Complete")
                .gameTextSize(40)
                .scaleEffect(scaleWinTitle ? 1 : 0)
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
            .buttonCornerRadius(16)
            .buttonHighlights(true)
            .buttonPadding(value: 8)
            .opacity(0.8)
            .onButtonPress {
                // Next Level
                // self.model = .demo
                self.scene.reload()
            }
        }
    }
}

// Lost View
fileprivate extension GameView {
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
        .buttonCornerRadius(0)
        .buttonHighlights(false)
        .buttonPadding(value: 4)
    }
}

// Menu View
fileprivate extension GameView {
    var menu: some View {
        HStack {
            GameButton {
                Text("🎁")
                    .frame(width: 32)
                    .grayscale(self.canCollectGift ? 0.9 : 0.9)
                    .opacity(self.canCollectGift ? 1.0 : 0.5)
            }
            .foregroundColor(canCollectGift ? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)) : .pink)
            .onButtonPress {
                if !self.canCollectGift {
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
        .offset(x: 0, y: showMenu ? 0 : UIScreen.main.bounds.height / 4)
    }
}
// Detail View
fileprivate extension GameView {
    var levelDetail: some View {
        VStack {
            GameText("Level \(model.id)")
                .colorInvert()
        }
        .opacity(showLevelTitle ? 1 : 0)
    }
}

// *** Publisher Event Handling ***

// Game Will Load Event
fileprivate extension GameView {
    func willLoad(loaded: Bool) {
        // Only animate loading screen when the scene is not loaded yet.
        if loaded {
            return
        }
        
        withAnimation(Animation.easeInOut(duration: 0.3)) {
            self.hideGame = true
        }
        
        withAnimation(Animation.easeInOut(duration: 0.3).delay(0.15)) {
            self.showLevelTitle = true
        }
        
        withAnimation(Animation.easeInOut(duration: 0.3).delay(1.15)) {
            self.hideGame = false
        }
        
        withAnimation(Animation.easeInOut(duration: 0.55).delay(1.45)) {
            self.showLevelTitle = false
        }
    }
}
// On Playing State Change Event
fileprivate extension GameView {
    func onPlayingChange(value: Bool) {
        withAnimation(Animation.linear(duration: 0.3)) {
            self.showMenu = !value
        }
    }
}
// On Win Event
fileprivate extension GameView {
    func onWin(value: Bool) {
        if value {
            print("Player Won")
        }
        
        withAnimation(Animation.linear(duration: 0.3)) {
            self.showContinueButton = value
        }
        
        withAnimation(Animation.interpolatingSpring(stiffness: 100, damping: 10).delay(0.3)) {
            self.showContinueLabel = value
            self.scaleWinTitle = value
        }
        
        withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
            self.glowContinue = value
        }
    }
}
// On Lost Event
fileprivate extension GameView {
    func onLost(value: Bool) {
        if value {
            print("Player has Lost.")
        }
        
        withAnimation(Animation.linear(duration: 0.3)) {
            self.showSkipButton = value
        }
        
        withAnimation(Animation.linear(duration: 0.3).delay(0.3)) {
            self.showAdButton = value
        }
        
        withAnimation(Animation.linear(duration: 0.3).delay(0.6)) {
            self.showRetryButton = value
        }
        
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

// *** Preview ***

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(level: GameData.level(named: "You Betcha")!)
    }
}
