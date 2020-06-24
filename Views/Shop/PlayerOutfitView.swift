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
    
    @ObservedObject var storage = Storage.current
    
    var outfit: PlayerOutfit?
    let isAnimated: Bool
    
    init() {
        self.outfit = nil
        self.isAnimated = true
    }
    
    init(outfit: PlayerOutfit?) {
        self.outfit = outfit
        self.isAnimated = false
        
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
            Color("shop-tile")
                .cornerRadius(8)
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
                    .brightness((outfit?.isUnlocked ?? false || (isAnimated && storage.outfit.isUnlocked)) ? 0 : -1)
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
