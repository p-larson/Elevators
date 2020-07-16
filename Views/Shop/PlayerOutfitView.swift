//
//  PlayerOutfitView.swift
//  Elevators
//
//  Created by Peter Larson on 6/2/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct PlayerOutfitView: View {
    
    @State var image = String()
    
    @ObservedObject var storage = GameData
    
    var outfit: PlayerOutfit?
    let isAnimated: Bool
    let hasBackground: Bool
    let isDisplay: Bool
    
    init() {
        self.outfit = nil
        self.isAnimated = true
        self.hasBackground = true
        self.isDisplay = false
    }
    
    init(outfit: PlayerOutfit?, hasBackground: Bool = true, isDisplay: Bool = false) {
        self.outfit = outfit
        self.isAnimated = false
        self.hasBackground = hasBackground
        self.isDisplay = isDisplay
        
        // Set the default image before animation.
        if let outfit = self.outfit {
            var name: String!
            
            if outfit.isSymmetric {
                name = "\(outfit.rawValue)-\(PlayerState.idle)-1"
            } else {
                name = "\(outfit.rawValue)-\(PlayerState.idle)-\(PlayerDirection.right)-1"
            }

            self._image = State(initialValue: name)
        }
    }
    
    func gif() {
        var frame = 1
        
        guard self.isAnimated else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.0 / 16.0, repeats: true) { (timer) in
            
            if frame < 14 {
                frame+=1
            } else {
                frame = 1
            }
            
            if self.storage.outfit.isSymmetric {
                self.image = "\(self.storage.outfit.rawValue)-\(PlayerState.idle)-\(frame)"
            } else {
                self.image = "\(self.storage.outfit.rawValue)-\(PlayerState.idle)-\(PlayerDirection.right)-\(frame)"
            }
        }
    }
    
    var body: some View {
        ZStack {
            if hasBackground {
                Color("shop-tile")
                    .cornerRadius(8)
            }
            if outfit == nil && !isAnimated {
                Text("Coming Soon")
                    .font(.custom("Futura", size: 16))
                    .rotationEffect(.init(degrees: -45))
                    .foregroundColor(.white)
                    .brightness(-0.5)
                    .minimumScaleFactor(0.5)
            }
            
            if outfit != nil || isAnimated {
                Image(self.image)
                    .resizable()
                    .scaledToFit()
                    .onAppear(perform: gif)
                    .padding()
                    .grayscale((outfit?.isUnlocked ?? false || (isAnimated && storage.outfit.isUnlocked) || isDisplay) ? 0 : 0.9)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(minHeight: 0, maxHeight: .infinity)
    }
}

struct PlayerOutfitView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            ScrollView {
                PlayerOutfitView(outfit: nil)
                ForEach(PlayerOutfit.allCases, id: \.self) { outfit in
                    PlayerOutfitView(outfit: outfit)
                }
            }
        }
    .previewDevice("iPhone X")
    }
}
