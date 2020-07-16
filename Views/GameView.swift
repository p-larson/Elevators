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
    // State
    @State var showShop = false
    @State var showDailyPrize = false
    @State var hasCollectedDailyGift = false
    @State var developer = true
    @State var showDeveloperView = false
    @State var model: LevelModel
    
    var body: some View {
        ZStack {
            GameBackground()
            GameContainerView()
                .edgesIgnoringSafeArea(.all)
                .zIndex(1)

            OverheadView(model: $model, showShop: $showShop, showDailyGift: $showDailyPrize)
                .zIndex(2)
            
            if showShop {
                ShopView(isShowing: $showShop)
                    .zIndex(3)
            }
            
            if showDailyPrize {
                DailyGiftView(isShowing: $showDailyPrize, hasCollectedDailyGift: $hasCollectedDailyGift)
                    .zIndex(4)
            }
            
            CoinCounterView()
                .zIndex(5)
        }
        .environmentObject(GameScene(model: model))
        .statusBar(hidden: true)
        .font(.custom("Futura Medium", size: 32))
    }
}

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameView(model: GameData.level(named: "you betcha")!)
            .previewDevice("iPhone 11")
    }
}

