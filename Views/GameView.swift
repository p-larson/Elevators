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
    
    @State var isLoading = true
    @State var isShopping = false
    @State var isCollectingDailyPrize = false
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
                .opacity(scene.isPlaying ? 1 : 0.75)
                .animation(.linear)
            
            if scene.hasLost {
                LoseView()
                    .zIndex(2)
            }
            
            ConfettiView(isEmitting: scene.hasWon)
                .zIndex(3)
            
            if !scene.isPlaying {
                OverheadView()
                    .zIndex(4)
                    .animation(.linear(duration: 0.3))
            }
            
            CoinCounterView()
                .zIndex(6)

            if isLoading {
                LoadingView(isShowing: $isLoading)
                    .transition(.opacity)
                    .animation(.linear)
                    .zIndex(10)
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
        GameView(model: Storage.current.level(named: "you betcha")!)
            .previewDevice("iPhone 11")
    }
}

