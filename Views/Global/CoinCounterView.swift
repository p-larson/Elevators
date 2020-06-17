//
//  OverlayDisplayView.swift
//  Elevators
//
//  Created by Peter Larson on 5/20/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI
//import SwiftFX

struct CoinCounterView: View {
    
    static let length: CGFloat = 24
    
    @ObservedObject var storage = Storage.current
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                HStack {
                    Image("coin")
                        .resizable()
                        .frame(width: CoinCounterView.length, height: CoinCounterView.length)
                    Text(self.storage.coins.description)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .font(.custom("Futura Medium", size: CoinCounterView.length))
                        .fixedSize()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(Capsule().foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.15), radius: 0, x: 0, y: 5))
                .transition(
                    AnyTransition
                        .asymmetric(
                            insertion: AnyTransition.scale(scale: 1.2),
                            removal: AnyTransition.scale(scale: 1.0)
                    )
                )
                .animation(.linear)
                .id(self.storage.coins.description)
            }
            .frame(height: 32)
            .padding(.horizontal, 16)
            
            Spacer()
        }.statusBar(hidden: true)
    }
}

struct CoinCounterTestView: View {
    
    var body: some View {
        ZStack {
            CoinCounterView()
            Button("+") {
                withAnimation {
                    Storage.current.coins += 1
                }
            }
        }
    }
}

struct CoinCounterPreviews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            CoinCounterTestView()
        }.previewDevice("iPhone 11")
    }
}
