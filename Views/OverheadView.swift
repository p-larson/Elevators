//
//  Overhead2View.swift
//  Elevators
//
//  Created by Peter Larson on 7/7/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct OverheadView: View {
    // Environment
    @EnvironmentObject var scene: GameScene
    // Control
    @Binding var showShop: Bool
    @Binding var showDailyGift: Bool
    // State
    @State private var canCollectDailyPrize = true
    @State private var showPlayButton = false
    @State private var showShopButton = false
    @State private var showDailyGiftButton = false
    @State private var showDeveloperButton = false
    
    func showButtons(_ value: Bool) {
        withAnimation(Animation.interpolatingSpring(stiffness: 100, damping: 10)) {
            self.showPlayButton = value
        }
        
        withAnimation(Animation.interpolatingSpring(stiffness: 100, damping: 10).delay(0.15)) {
            self.showShopButton = value
        }
        
        withAnimation(Animation.interpolatingSpring(stiffness: 100, damping: 10).delay(0.3)) {
            self.showDailyGiftButton = value
        }
        
        withAnimation(Animation.easeInOut(duration: 0.3).delay(0.6)) {
            self.showDeveloperButton = value
        }
    }
    
    var body: some View {
        VStack() {
            Button("Enter Developer Mode") {
                
            }
            .scaleEffect(0.5)
            .opacity(showDeveloperButton ? 1 : 0)
            .foregroundColor(.white)
            Spacer()
            HStack {
                GameButton {
                    Text("▶︎")
                        .brightness(1)
                }
                .offset(x: 0, y: showPlayButton ? 0 : 200)
                .onButtonPress {
                    // Reload if needed
                    if self.scene.hasLost {
                        self.scene.reload()
                    }
                    // Start playing
                    self.scene.isPlaying = true
                    // Hide buttons
                    self.showButtons(false)
                }
                
                
                GameButton {
                    Text("🛒")
                        .brightness(1)
                }
                .offset(x: 0, y: showShopButton ? 0 : 200)
                .onButtonPress {
                    self.showShop = true
                }
                
                GameButton {
                    Text("🎁")
                        .modifier(NotificationModifier(delay: 2.0, duration: 0.2, isEnabled: self.$canCollectDailyPrize))
                        .brightness(self.canCollectDailyPrize ? 0 : -1)
                }
                .offset(x: 0, y: showDailyGiftButton ? 0 : 200)
                .onButtonPress {
                    self.showDailyGift = true
                }
            }
        }
        .buttonPadding(value: 8.0)
        .buttonHighlights(true)
        .doesButtonScale(enabled: false)
        .foregroundColor(Color("theme-1"))
        .font(.custom("Futura Medium", size: 32))
        .onAppear {
            self.showButtons(true)
        }
            
        .onReceive(scene.$isPlaying) { (output) in
            self.showPlayButton = false
            self.showShopButton = false
            self.showDailyGiftButton = false
        }
    }
}

struct Overhead2View_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            OverheadView(showShop: .constant(false), showDailyGift: .constant(false))
        }
    }
}
