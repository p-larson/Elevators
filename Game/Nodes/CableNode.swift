//
//  CableNode.swift
//  Elevators
//
//  Created by Peter Larson on 4/21/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SpriteKit

class CableNode: SKSpriteNode {
    init(length: Int) {
        super.init(texture: nil, color: .black, size: GameScene.cableSize(of: length))
        self.anchorPoint = .init(x: 0.5, y: 0)
        self.zPosition = ZPosition.cable
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
