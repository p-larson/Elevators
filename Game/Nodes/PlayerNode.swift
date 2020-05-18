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
    var floor: Int
    var target: Int? = nil
    
    fileprivate(set) var isMoving: Bool = false
    
    fileprivate(set) var isInsideElevator: Bool = false {
        didSet {
            self.zPosition = isInsideElevator ? ZPosition.playerInside : ZPosition.playerOutside
        }
    }
    
    init(floor: Int = 1) {
        self.floor = floor
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
    func move(to slot: Int) {
        let translation = slot - self.slot
        
//        self.slot = slot
        self.isMoving = true
        
        self.run(
            SKAction.sequence(
                [
                    SKAction.repeat(
                        SKAction.sequence(
                            [
                                SKAction.run {
                                    self.slot += (translation / abs(translation))
                                    self.gamescene?.updateTarget()
                                },
                                SKAction
                                    .moveBy(
                                        x: GameScene.slotWidth * CGFloat(translation / abs(translation)),
                                        y: 0, duration: GameScene.playerSpeed
                                )
                            ]
                        ),
                        count: abs(translation)
                    ),
                    SKAction.run {
                        self.isMoving = false  
                    }
                ]
            )
        )
        
        PlayerSkin.current.set(state: .run)
        PlayerSkin.current.set(direction: translation > 0 ? .right : .left)

//        self.run(
//            SKAction.sequence(
//                [
//                    SKAction.moveBy(
//                        x: GameScene.slotWidth * CGFloat(translation),
//                        y: 0,
//                        duration: TimeInterval(abs(translation)) * GameScene.playerSpeed
//                    ),
//                    SKAction.run {
//                        self.isMoving = false
//                        PlayerSkin.current.set(state: .idle)
//                    }
//                ]
//            )
//        )
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
