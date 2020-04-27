//
//  PlayerNode.swift
//  Elevators
//
//  Created by Peter Larson on 4/21/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerNode: SKSpriteNode {
    var slot: Int = 0
    var floor: Int = 1
    var target: Int? = nil
    
    fileprivate(set) var isInsideElevator: Bool = false {
        didSet {
            self.zPosition = isInsideElevator ? ZPosition.playerInside : ZPosition.playerOutside
        }
    }
    
    init() {
        super.init(texture: PlayerSkin.current.next(), color: .clear, size: GameScene.playerSize)
        self.anchorPoint = .init(x: 0.5, y: 0)
        self.zPosition = ZPosition.playerOutside
        PlayerSkin.current.animate(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlayerNode {
    
    private var isMoving: Bool {
        return action(forKey: "move") != nil
    }
    
    func right() {
        guard !isMoving else {
            return
        }
        
        
    }
    
    func left() {
        guard !isMoving else {
            return
        }
        
        
    }
}

extension PlayerNode {
    func enter() {
        // Fadeout,
        self.run(
            SKAction.sequence(
                [
                    SKAction.fadeOut(withDuration: GameScene.doorSpeed),
                    SKAction.run {
                        self.isInsideElevator = true
                    }
                ]
            )
        )
    }
    
    func exit() {
        self.run(
            SKAction.sequence(
                [
                    SKAction.fadeIn(withDuration: GameScene.doorSpeed),
                    SKAction.run {
                        self.isInsideElevator = false
                    }
                ]
            )
        )
    }
}
