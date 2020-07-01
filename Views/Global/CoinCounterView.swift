//
//  OverlayDisplayView.swift
//  Elevators
//
//  Created by Peter Larson on 5/20/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI
import MovingNumbersView

struct CoinCounterView: View {
    
    static let length: CGFloat = 24
    
    @ObservedObject var storage = Storage.current
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                HStack(spacing: 0) {
                    Text("$")
                        .font(.system(size: 16))
                    MovingNumbersView(number: storage.cash, numberOfDecimalPlaces: 2) { string in
                        Text(string)
                    }
                    .font(.custom("Futura", size: 24))
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
            }
            .frame(height: 32)
            .padding(.horizontal, 16)
            
            Spacer()
        }
    }
}

struct CoinCounterTestView: View {
    
    var body: some View {
        ZStack {
            CoinCounterView()
            Button("+") {
                withAnimation {
                    Storage.current.cash += .random(in: 1 ..< 100)
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
