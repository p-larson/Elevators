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
    // Game Data
    @ObservedObject var scene: GameScene
    // State
    @State var showShop = false
    @State var showDailyPrize = false
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
    
    var body: some View {
        ZStack {
            GameBackground()
            GameContainerView(model: model)
                .edgesIgnoringSafeArea(.all)
                .zIndex(1)
            
            if scene.hasLost {
                LoseView()
                    .zIndex(2)
            }
            
            ConfettiView(isEmitting: scene.hasWon)
                .zIndex(3)
            
            if !scene.isPlaying {
                OverheadView(showShop: $showShop, showDailyPrize: $showDailyPrize)
                    // .transition(.move(edge: .bottom))
                    .zIndex(4)
            }
            
            if showShop {
                ShopView(isShowing: $showShop)
                    // .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(5)
            }
            
            if showDailyPrize {
                DailyPrizeView(isShowing: $showDailyPrize)
                    // .transition(.move(edge: .bottom))
                    .zIndex(6)
            }
            
            CoinCounterView()
                .zIndex(7)
        }
        .animation(.easeInOut(duration: 0.3), value: scene.isPlaying)
        // .animation(.easeInOut(duration: 0.3), value: showShop)
        .animation(.easeInOut(duration: 0.3), value: showDailyPrize)
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
        GameView(model: Storage.current.level(named: "you betcha")!)
            .previewDevice("iPhone 11")
    }
}

