//
//  OverheadView.swift
//  Elevators
//
//  Created by Peter Larson on 6/29/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct OverheadView: View {
    
    @EnvironmentObject var scene: GameScene
    
    @State var canCollectDailyPrize: Bool = true
    @State var showDeveloperMenu: Bool = false
    @State var isShopping: Bool = false
    @State var isCollectingDailyPrize: Bool = false
    
    func play() {
        if scene.hasLost {
            scene.reload()
        }
        
        self.scene.isPlaying = true
    }
    
    func openShop() {
        self.isShopping = true
    }
    
    func tryOpeningDailyPrize() {
        guard canCollectDailyPrize else {
            return
        }
        
        self.canCollectDailyPrize = false
        self.isCollectingDailyPrize = true
    }
    
    func openDeveloperMenu() {
        self.showDeveloperMenu = true
    }
    
    var body: some View {
        ZStack {
            VStack {
                Button("/dev") {
                    self.showDeveloperMenu.toggle()
                }
                .font(.custom("Futura", size: 16))
                .foregroundColor(Color("theme-2"))
                Spacer()
                HStack {
                    GameButton {
                        Text("▶︎")
                            .brightness(1)
                    }
                    .onButtonPress(play)
                    
                    GameButton {
                        Text("🛒")
                            .brightness(1)
                    }
                    .onButtonPress(openShop)
                    GameButton {
                        Text("🎁")
                            .modifier(NotificationModifier(delay: 2.0, duration: 0.2, isEnabled: self.$canCollectDailyPrize))
                            
                            .brightness(self.canCollectDailyPrize ? 0 : -1)
                        
                    }
                    .onButtonPress(tryOpeningDailyPrize)
                    .foregroundColor(self.canCollectDailyPrize ? .pink : .gray)
                }
            }
            .compositingGroup()
            .buttonPadding(value: 8.0)
            .buttonHighlights(true)
            .doesButtonScale(enabled: false)
            .foregroundColor(Color("theme-1"))
            .font(.custom("Futura Medium", size: 32))
            .padding(.bottom, 8)
            .padding(.horizontal, 16)
            .zIndex(1)
            
            if isShopping {
                ShopView(isShowing: $isShopping)
                    .zIndex(2)
            }
            
            if isCollectingDailyPrize {
                DailyPrizeView(isShowing: $isCollectingDailyPrize)
                    .zIndex(3)
            }
            
            if showDeveloperMenu {
                DeveloperView(scene: self.scene, isShowing: $showDeveloperMenu)
                    .zIndex(8)
            }
        }
        .transition(AnyTransition.move(edge: .bottom))
        .animation(.linear(duration: 0.3))
    }
}

struct OverheadDemoView: View {
    @ObservedObject var scene = GameScene(model: .demo)
    
    var body: some View {
        ZStack {
            GameBackground()
                .onTapGesture {
                    self.scene.isPlaying = false
            }
            .zIndex(1)
            
            if !scene.isPlaying {
                OverheadView()
                    .zIndex(2)
                    .animation(.easeInOut(duration: 0.3))
            }
        }
        .environmentObject(scene)
    }
}

struct OverheadView_Previews: PreviewProvider {
    static var previews: some View {
        OverheadDemoView()
    }
}
