//
//  LoseView.swift
//  Elevators
//
//  Created by Peter Larson on 6/30/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct LoseView: View {
    
    @EnvironmentObject var scene: GameScene
    
    var transition: AnyTransition {
        AnyTransition
            .modifier(active: ScaleModifier(x: 1, y: 0), identity: ScaleModifier(x: 1, y: 1))
            .animation(Animation.easeInOut(duration: 0.15).delay(0.15))
    }
    
    var body: some View {
        VStack(spacing: 8) {
            GameButton {
                HStack(spacing: 4) {
                    Text("Skip Level ➞")
                    Image("coin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("25")
                        .foregroundColor(Color("Coin"))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.vertical, 4)
                .foregroundColor(.white)
            }
            .foregroundColor(Color.red.opacity(0.75))
            
            GameButton {
                HStack(spacing: 4) {
                    Text("Watch Ad Reward")
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.vertical, 4)
                .foregroundColor(.white)
            }
            .foregroundColor(Color.purple.opacity(0.75))
        }
        .buttonHighlights(false)
        .buttonHighlightsPadding(0)
        .buttonCornerRadius(0)
        .buttonPadding(value: 0)
        .doesButtonScale(enabled: false)
        .font(.custom("Futura Condensed Medium", size: 24))
        .transition(transition)
    }
}

struct LoseDemoView: View {
    @State var isShowing: Bool = true
    
    var body: some View {
        ZStack {
            GameBackground()
                .onTapGesture {
                    self.isShowing.toggle()
                }
                .zIndex(1)
            
            if isShowing {
                OverheadView()
                    .zIndex(2)
                LoseView()
                    .zIndex(2)
            }
        }
        .animation(.default)
        .environmentObject(GameScene(model: .demo))
    }
}

struct LoseView_Previews: PreviewProvider {
    static var previews: some View {
        LoseDemoView()
    }
}
