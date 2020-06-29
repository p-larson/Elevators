//
//  PlayerNode.swift
//  Elevators
//
//  Created by Peter Larson on 4/21/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SpriteKit
import Haptica

class PlayerNode: SKSpriteNode {
    var slot: Int = 0
    var floor: Int
    var target: Int? = nil
    var willEnter = false
    
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
    
    func stop() -> SKAction {
        .run {
            self.isMoving = false
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

        Haptic.impact(.light).generate()
        
        PlayerSkin.current.set(state: .idle)
        PlayerSkin.current.set(direction: right ? .right : .left)
        
        self.slot += right ? 1 : -1
        
        self.run(
            .sequence(
                [scrunch, .group([bounce, press, .moveBy(x: x, y: 0, duration: GameScene.playerSpeed)]), stop(), .run(check)]
            )
        )
    }
    
    func enter() {
        // Fadeout
        self.isInsideElevator = true
        self.run(
            SKAction.fadeOut(withDuration: GameScene.doorSpeed)
        )
    }
    
    func exit() {

        self.isInsideElevator = false
        
        self.run(
            SKAction.sequence(
                [
                    SKAction.fadeIn(withDuration: GameScene.doorSpeed),
                    SKAction.run {
                        self.gamescene?.checkCoins()
                    },
                    // .run(nextActionInQueue)
                ]
            )
        )
    }
    
    func check() {
        if willEnter {
            gamescene?.ride()
        }
        
        willEnter = false
    }

}
