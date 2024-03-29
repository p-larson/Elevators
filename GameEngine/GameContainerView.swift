//
//  GameContainerView.swift
//  Elevators
//
//  Created by Peter Larson on 5/21/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI
import SpriteKit

struct GameContainerView: UIViewRepresentable {
    typealias UIViewType = SKView
        
    @EnvironmentObject var scene: GameScene
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView(frame: UIScreen.main.bounds)
        
        view.showsNodeCount = false
        view.showsFPS = false
        view.preferredFramesPerSecond = 60
        view.presentScene(scene)
        view.isAsynchronous = true
        view.allowsTransparency = true
        // Let the user start the game
        view.isUserInteractionEnabled = true
        
        view.showsPhysics = true
        
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        uiView.isUserInteractionEnabled = !scene.hasLost && !scene.hasWon
    }
}
