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
    // GameScene
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
    // Developer (For Debugging)
    @State var developer = true
    @State var showDeveloperView = false
    // Game Model
    @State var model: LevelModel
    // Initializer with Model
    init(model: LevelModel) {
        self._model = State(initialValue: model)
        self._scene = ObservedObject(initialValue: GameScene(model: model))
    }
    // Menu
    // 
    var menu: some View {
        ZStack {
            if !scene.isPlaying || scene.hasWon || scene.hasLost {
                VStack {
                    if scene.hasLost {
                        Spacer()
                        Text("Level Lost")
                            .foregroundColor(.white)
                            .font(.custom("Futura Bold", size: 48))
                        Spacer()
                    }
                }
                VStack(spacing: 8) {
                    Spacer()
                    HStack {
                        if developer {
                            // Developer Button
                            GameButton {
                                Text("👾")
                            }.onButtonPress {
                                self.showDeveloperView = true
                                
                            }
                        }
                        Spacer()
                        // Daily Prize Button
                        GameButton {
                            Text("🎁")
                        }.onButtonPress {
                            self.isCollectingDailyPrize = true
                            self.showLevelNumber = false
                        }
                    }
                    HStack {
                        // Previous Level Button
                        GameButton {
                            Text("👈")
                        }.onButtonPress {
                            withAnimation {
                                self.showTransition = true
                            }
                        }.disabled(isTransitioning)
                        Spacer()
                        
                        // Shop Button
                        GameButton {
                            Text("🛒")
                        }.onButtonPress {
                            self.isShopping = true
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
                .font(.custom("Futura Bold", size: 16))
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
    
    var gameStateViews: some View {
        ZStack {
            //            if !scene.isPlaying {
            //                VStack {
            //                    Spacer()
            //                    PressIndicatorView(model: $model)
            //                        .transition(.opacity)
            //                }
            //                .zIndex(1)
            //                .onTapGesture {
            //                    withAnimation {
            //                        self.scene.isPlaying = true
            //                    }
            //
            //                    print("tap")
            //                }
            //            }
            
            if scene.hasWon {
                VStack {
                    Text("Level \(model.number) Complete!")
                        .padding(.top, UIScreen.main.bounds.height / 4)
                        .font(.custom("Futura Bold", size: 32))
                        .foregroundColor(.white)
                    Spacer()
                    
                }
            }
        }
        //        .transition(.opacity)
    }
    
    var body: some View {
        ZStack {
            GameBackground()
                .zIndex(0)
            GameContainerView(model: model)
                .edgesIgnoringSafeArea(.all)
                .zIndex(1)
                .blur(radius: scene.hasLost ? 10.0 : 0)
                // 3d scroll
                //.rotation3DEffect(self.scene.isPlayerRiding ? .degrees(3 * (self.scene.isSendingElevator ? -1 : 1)) : .degrees(0), axis: (1, 0, 0))
                //.animation(.linear(duration: 0.1), value: self.scene.isPlayerRiding)
                .onAppear {
                    withAnimation {
                        self.scene.isPlaying = false
                        self.showLevelNumber = true
                    }
            }
            
            self.gameStateViews
                .zIndex(2)
            
            self.menu
                .zIndex(3)
            
            ConfettiView(isEmitting: scene.hasWon)
                .zIndex(4)
            
            self.screens
                .zIndex(5)
            
            CoinCounterView()
                .zIndex(6)
            
            if showTransition {
                TransitionView(
                    showTransition: $showTransition,
                    isTransitioning: $isTransitioning,
                    perform: $transition
                )
                    .zIndex(7)
            }
            
            if showDeveloperView {
                DeveloperView(scene: self.scene, isShowing: $showDeveloperView)
                    .zIndex(8)
            }
        }
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

