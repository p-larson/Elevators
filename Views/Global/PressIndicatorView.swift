//
//  PressIndicatorView.swift
//  Elevators
//
//  Created by Peter Larson on 5/19/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct PressIndicatorView: View {
    
    @State private var animating: Bool = false
    @Binding var model: LevelModel
    
    var body: some View {
        VStack {
            Text("Level \(model.id)")
                .font(.custom("Futura Medium", size: 48))
                .foregroundColor(Color.white.opacity(0.8))
            Text("👆")
                .font(.system(size: 64))
                .offset(x: 0, y: self.animating ? -16 : 0)
                .onAppear(perform: { self.animating.toggle() })
                .shadow(color: Color.black.opacity(0.15), radius: 0, x: 0, y: 5)
                .animation(
                    Animation
                        .easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true)
            )
        }
        .animation(nil)
    }
}

struct PressIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            PressIndicatorView(model: .constant(.demo))
        }.edgesIgnoringSafeArea(.all)
    }
}
