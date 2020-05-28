//
//  LevelView.swift
//  Elevators
//
//  Created by Peter Larson on 4/20/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    // Game
    @ObservedObject var scene: GameScene
        
    // Sub Views
    
    @State var isAnimating: Bool = false
    @State var isCollectingDailyPrize = false
    @State var isShopping = false
    @State var showLevelNumber = false
    
    // Transition View Management
    @State var showTransition = false
    @State var isTransitioning = false
    @State var transition: (() -> Void)? = nil
    
    @State var developer = true
    @State var showDeveloperView = false
    
    @State var model: LevelModel
    
    init(model: LevelModel) {
        self._model = State(initialValue: model)
        self._scene = ObservedObject(initialValue: GameScene(model: model))
    }
    
    var menu: some View {
        ZStack {
            if !scene.isPlaying || scene.hasWon || scene.hasLost {
                VStack(spacing: 8) {
                    if scene.hasLost {
                        Spacer()
                        Text("Level Lost")
                            .foregroundColor(.white)
                            .font(.custom("Futura Bold", size: 48))
                    }
                    
                    Spacer()
                    HStack {
                        if developer {
                            GameButton {
                                Text("👾")
                            }.onButtonPress {
                                withAnimation(.linear) {
                                    self.showDeveloperView = true
                                }
                            }
                        }
                        Spacer()
                        GameButton {
                            Text("🎁")
                        }.onButtonPress {
                            withAnimation(.linear) {
                                self.isCollectingDailyPrize = true
                                self.showLevelNumber = false
                            }
                        }
                    }
                    HStack {
                        GameButton {
                            Text("👈")
                        }.onButtonPress {
                            withAnimation {
                                self.showTransition = true
                            }
                        }.disabled(isTransitioning)
                        Spacer()
                        
                        GameButton {
                            Text("🛒")
                        }.onButtonPress {
                            withAnimation {
                                self.isShopping = true
                                self.showLevelNumber = false
                            }
                        }
                    }
                    
                    if scene.hasWon {
                        // Play Next Level
                        GameButton {
                            Text("Play Next Level")
                                .foregroundColor(.black)
                                .frame(minWidth: 0, maxWidth: .infinity)
                        }.onButtonPress {
                            
                            self.transition = {
                                self.scene.model = self.model
                            }
                            
                            self.showTransition = true
                        }
                    }
                    
                    if scene.hasLost {
                        // Watch Ad
                        GameButton {
                            HStack {
                                Spacer()
                                Image("watch-video")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                                    .brightness(-1)
                                Text("Watch Ad for 50 Coins")
                                    .foregroundColor(.black)
                                    .transition(.slide)
                                Spacer()
                            }
                            
                        }
                        .foregroundColor(.white)
                        // Replay Level
                        GameButton {
                            HStack {
                                Spacer()
                                Image("replay")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                                    .brightness(-1)
                                Text("Retry")
                                    .foregroundColor(.black)
                                Spacer()
                            }
                        }.onButtonPress {
                            self.transition = {
                                print("Retrying")
                                self.scene.reload()
                            }
                            
                            self.showTransition = true
                        }
                    }
                }
                .buttonPadding(value: 5)
                .padding(.horizontal, 16)
                .font(.custom("Futura Bold", size: 24))
                .foregroundColor(.white)
                .zIndex(2)
                .transition(AnyTransition.move(edge: .bottom).animation(.linear))
                
            }
        }
    }
    
    var screens: some View {
        ZStack {
            if isCollectingDailyPrize {
                DailyPrizeView(isShowing: $isCollectingDailyPrize)
                    .zIndex(1)
                    .onDisappear {
                        self.showLevelNumber = true
                }
            }
            
            if isShopping {
                ShopView(isShowing: self.$isShopping)
                    .zIndex(2)
                    .onDisappear {
                        self.showLevelNumber = true
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            GameBackground()
            GameContainerView(
                model: model
            )
                .edgesIgnoringSafeArea(.all)
                .zIndex(0)
                .onAppear {
                    withAnimation {
                        self.scene.isPlaying = false
                        self.showLevelNumber = true
                    }
            }
                
            .blur(radius: scene.hasLost ? 10.0 : 0)
            
            if !scene.isPlaying {
                VStack {
                    Spacer()
                    PressIndicatorView(model: $model)
                        .transition(.opacity)
                }
                .zIndex(1)
                .allowsHitTesting(false)
            }
            
            if scene.hasWon {
                VStack {
                    Text("Level \(model.number) Complete!")
                        .padding(.top, UIScreen.main.bounds.height / 4)
                        .font(.custom("Futura Bold", size: 32))
                        .foregroundColor(.white)
                    Spacer()
                    
                }
            }
            
            self.menu
                .zIndex(5)
            
            ConfettiView(isEmitting: scene.hasWon)
                .zIndex(6)
            
            self.screens
                .zIndex(7)
            
            CoinCounterView()
                .zIndex(8)
            
            if showTransition {
                TransitionView(
                    showTransition: $showTransition,
                    isTransitioning: $isTransitioning,
                    perform: $transition
                )
                    .zIndex(9)
            }
            
            if showDeveloperView {
                DeveloperView(isShowing: $showDeveloperView)
                    .zIndex(10)
            }
        }
        .animation(.linear)
        .transition(.opacity)
        .environmentObject(scene)
        .statusBar(hidden: true)
        .font(.custom("Futura Medium", size: 32))
    }
}

extension GameView {
    var introTransition: AnyTransition {
        AnyTransition.asymmetric(
            insertion: AnyTransition.move(edge: .leading),
            removal: AnyTransition.move(edge: .trailing)
        ).animation(.easeInOut)
    }
}

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameView(model: .demo)
            .previewDevice("iPhone 11")
    }
}

