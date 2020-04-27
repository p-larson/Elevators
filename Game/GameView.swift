//
//  GameView.swift
//  Elevators
//
//  Created by Peter Larson on 4/20/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI
import SpriteKit

struct GameView: UIViewRepresentable {
    typealias UIViewType = SKView
    
    let scene: GameScene
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView(frame: UIScreen.main.bounds)
        
        view.showsNodeCount = true
        view.showsFPS = true
        view.showsLargeContentViewer = true
        view.presentScene(scene)
        
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        return
    }
}

struct GameView_Previews: PreviewProvider {
    static var demo: GameScene {
        GameScene(
            floors: 3,
            elevators: [
                ElevatorModel(floor: 1, slot: 1, target: 3),
                ElevatorModel(floor: 1, slot: 3, target: 3)
            ]
        )
    }
    
    static var previews: some View {
        GameView(
            scene: demo
        ).previewDevice("iPhone X").edgesIgnoringSafeArea(.all).statusBar(hidden: true)
    }
}

