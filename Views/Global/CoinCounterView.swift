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
                        .animation(nil)
                        .fixedSize()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(Capsule().foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.15), radius: 0, x: 0, y: 5))
            }.frame(height: 32).padding(.horizontal, 16)
            
            Spacer()
        }
    }
}

struct OverlayDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            CoinCounterView()
        }.previewDevice("iPhone 11")
    }
}
