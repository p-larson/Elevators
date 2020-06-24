//
//  SKNode.swift
//  Elevators
//
//  Created by Peter Larson on 5/17/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode {
    var gamescene: GameScene? {
        scene as? GameScene
    }
}

extension SKNode {
    func showBoundingBox() {
        let node = SKShapeNode(rect: calculateAccumulatedFrame())
        
        node.lineWidth = 2
        node.strokeColor = .red
        node.fillColor = .clear
        
        self.addChild(node)
    }
}
