//
//  GameText.swift
//  Elevators
//
//  Created by Peter Larson on 7/8/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct GameText: View {
    
    @Environment(\.gameTextSize) var gameTextSize: CGFloat
    
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var background: some View {
        Text(text)
            .font(.custom("Being Strong Shadow", size: gameTextSize))
            .foregroundColor(.white)
    }
    
    var overlay: some View {
        Text(text)
            .padding(2)
            .font(.custom("Being Strong regular", size: gameTextSize))
            .foregroundColor(.black)
    }
    
    var body: some View {
        overlay
            .background(background)
            .fixedSize()
    }
}

struct GameText_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            GameText("Level 4 Completed!")
                .gameTextSize(32)
        }
    }
}
