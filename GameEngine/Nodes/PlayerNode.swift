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
        super.init(texture: PlayerSkin.current.nextTexture(), color: .clear, size: GameScene.playerSize)
        self.anchorPoint = .init(x: 0.5, y: 0)
        self.zPosition = ZPosition.playerOutside
        // self.showBoundingBox()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlayerNode {  
    
    var scrunch: SKAction {
        .scaleY(to: 0.5, duration: 0.1)
    }
    
    var press: SKAction {
        .scaleY(to: 1, duration: 0.1)
    }
    
    func stop(_ right: Bool) -> SKAction {
        .run {
            self.isMoving = false
            self.slot += right ? 1 : -1
            self.gamescene?.updateTarget()

            PlayerSkin.current.set(state: .idle)
        }
    }
    
    var bounce: SKAction {
        .sequence(
            [
                .moveBy(x: 0, y: frame.height / 5, duration: 0.1),
                .moveBy(x: 0, y: frame.height / -5, duration: 0.1),
            ]
        )
    }
    
    func move(right: Bool) {
        self.isMoving = true
        
        let x = (right ? 1 : -1) * (gamescene?.slotWidth ?? 0)

        PlayerSkin.current.set(state: .idle)
        PlayerSkin.current.set(direction: right ? .right : .left)
        
        self.run(
            .sequence(
                [scrunch, .group([bounce, press, .moveBy(x: x, y: 0, duration: GameScene.playerSpeed)]), stop(right)]
            )
        )
    }
    
//    func move(to slot: Int) {
//        // Scrunch
//
//    }
}

extension PlayerNode {
    func move(to slot: Int) {
        let translation = slot - self.slot
        
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
                                        x: (gamescene?.slotWidth ?? 0) * CGFloat(translation / abs(translation)),
                                        y: 0, duration: GameScene.playerSpeed
                                )
                            ]
                        ),
                        count: abs(translation)
                    ),
                    SKAction.run {
                        self.isMoving = false
                        PlayerSkin.current.set(state: .idle)
                    }
                ]
            )
        )
        
        PlayerSkin.current.set(state: .run)
        PlayerSkin.current.set(direction: translation > 0 ? .right : .left)
    }
}

extension PlayerNode {
    func enter() {
        // Fadeout
        self.isInsideElevator = true
        self.run(
            SKAction.fadeOut(withDuration: GameScene.doorSpeed)
        )
    }
    
    func exit() {
        self.run(
            SKAction.sequence(
                [
                    SKAction.fadeIn(withDuration: GameScene.doorSpeed),
                    SKAction.run {
                        self.isInsideElevator = false
                        self.gamescene?.checkCoins()
                    }
                ]
            )
        )
    }
}
