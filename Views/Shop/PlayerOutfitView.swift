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
    
    let outfit: PlayerOutfit
    
    func gif() {
        
        var frame = 1
        
        Timer.scheduledTimer(withTimeInterval: 1.0 / 16.0, repeats: true) { (timer) in
            if frame < 14 {
                frame+=1
            } else {
                frame = 1
            }
            
            if self.outfit.isSymmetric {
                self.image = "\(self.outfit.rawValue)-\(PlayerState.idle)-\(frame)"
            } else {
                self.image = "\(self.outfit.rawValue)-\(PlayerState.idle)-\(PlayerDirection.right)-\(frame)"
            }
        }
    }
    
    var body: some View {
        Image(self.image)
            .resizable()
            .scaledToFit()
            .onAppear(perform: gif)
    }
}

struct PlayerOutfitView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            ScrollView {
                PlayerOutfitView(outfit: .goose)
                PlayerOutfitView(outfit: .orange)
                PlayerOutfitView(outfit: .strawberry)
                PlayerOutfitView(outfit: .firefighter)
            }
        }
    }
}
