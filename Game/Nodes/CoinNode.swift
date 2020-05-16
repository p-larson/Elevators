//
//  CoinNode.swift
//  Elevators
//
//  Created by Peter Larson on 5/11/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SpriteKit

public class CoinNode: SKSpriteNode {
    
    let model: CoinModel
    
    init(model: CoinModel) {
        
        self.model = model
        
        super.init(texture: nil, color: .yellow, size: GameScene.coinSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension CoinNode {
    
    func idle() {
        run(
            SKAction.repeatForever(
                SKAction.sequence(
                    [
                        SKAction.moveBy(x: 0, y: 25, duration: 0.3),
                        SKAction.moveBy(x: 0, y: 25, duration: 0.3)
                    ]
                )
            )
        )
    }
    
    func collect() {
        self.run(
            SKAction.sequence(
                [
                    SKAction.moveBy(x: 0, y: 10, duration: 0.2),
                    SKAction.run{
                        self.removeFromParent()
                    }
                ]
            )
        )
    }
}