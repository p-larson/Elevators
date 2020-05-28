//
//  CoinCounter.swift
//  Elevators
//
//  Created by Peter Larson on 5/20/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI
//import SwiftFX

struct OverlayDisplayView: ViewModifier {
    
    static let HEIGHT: CGFloat = 32
    
    @Binding var level: LevelModel
    @Binding var showLevelNumber: Bool
    
    @ObservedObject var storage = Storage.current
    
    var overlay: some View {
        GeometryReader { proxy in
            HStack {
                Text("Level \(self.level.number)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.custom("Futura Medium", size: OverlayDisplayView.HEIGHT))
                    .opacity(self.showLevelNumber ? 1 : 0)
                    .animation(.linear)
                    .fixedSize()
                Spacer()
                Image("coin")
                    .resizable()
                    .scaledToFit()
                Text(self.storage.coins.description)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.custom("Futura Medium", size: OverlayDisplayView.HEIGHT))
                    .animation(nil)
                    .fixedSize()
            }
            .frame(width: proxy.size.width, height: 32)
            .position(x: proxy.size.width / 2, y: proxy.safeAreaInsets.top)
        }
        .padding(16)
        .statusBar(hidden: true)
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(overlay.zIndex(.infinity))
    }
}

struct CoinCounter_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
            .modifier(OverlayDisplayView(level: .constant(.demo), showLevelNumber: .constant(true)))
            .statusBar(hidden: true)
    }
}
