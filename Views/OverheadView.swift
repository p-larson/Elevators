//
//  Overhead2View.swift
//  Elevators
//
//  Created by Peter Larson on 7/7/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI
import Haptica

struct OverheadView: View {
    // Environment
    @EnvironmentObject var scene: GameScene
    // Control
    @Binding var showShop: Bool
    @Binding var showDailyGift: Bool
    @Binding var hasCollectedDailyGift: Bool
    // State
    @State private var canCollectDailyPrize = true
    @State private var showButtons = false
    
    func showButtons(_ value: Bool) {
        
        guard value != showButtons else {
            return
        }
        
        withAnimation(Animation.easeInOut(duration: 0.3)) {
            self.showButtons = value
        }
    }
    
    var body: some View {
        VStack() {
            Button("Enter Developer Mode") {
                
            }
            .scaleEffect(0.5)
            .opacity(showButtons ? 1 : 0)
            .foregroundColor(.white)
            Spacer()
            HStack {
                GameButton {
                    Text("▶︎")
                        .brightness(1)
                        .frame(width: 32)
                }
                .onButtonPress {
                    // Reload if needed
                    if self.scene.hasLost {
                        self.scene.reload()
                    }
                    // Start playing
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
                
                GameButton {
                    Text("🎁")
                        .frame(width: 32)
                }
                .foregroundColor(.pink)
                .onButtonPress {
                    if !self.hasCollectedDailyGift {
                        self.showDailyGift = true
                    } else {
                        Haptic.notification(.error).generate()
                    }
                }
                .grayscale(hasCollectedDailyGift ? 0.8 : 0)
                
            }
            .offset(x: 0, y: showButtons ? 0 : 200)
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
            self.showButtons(!output)
        }
    }
}

struct Overhead2View_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            OverheadView(showShop: .constant(false), showDailyGift: .constant(false), hasCollectedDailyGift: .constant(false))
        }.environmentObject(GameScene(model: .demo))
    }
}
