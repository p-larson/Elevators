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
    
    static let texture = SKTexture(imageNamed: "coin.png")
    
    let model: CoinModel
    
    var isCollected = false
    
    init(model: CoinModel) {
        
        self.model = model
        
        super.init(texture: CoinNode.texture, color: .yellow, size: GameScene.coinSize)
                
        self.zPosition = ZPosition.coin
        
        self.run(
            SKAction.repeatForever(
                SKAction.sequence(
                    [
                        SKAction.moveBy(x: 0, y: GameScene.coinSize.height / 2, duration: 1),
                        SKAction.moveBy(x: 0, y: GameScene.coinSize.height / 2, duration: 1).reversed()
                    ]
                )//.with(timing: SKActionTimingMode.easeIn)
            )
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension CoinNode {
    
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
        
        self.isCollected = true
        
        Storage.current.cash += 1
        
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
