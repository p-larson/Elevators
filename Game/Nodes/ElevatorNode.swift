//
//  ElevatorNode.swift
//  Elevators
//
//  Created by Peter Larson on 4/19/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SpriteKit

class ElevatorNode: SKNode {
    private var background: SKSpriteNode!
    private var overlay: SKSpriteNode!
    
    let floor: Int, slot: Int
    
    public var isOpen: Bool = false
    
    init(floor: Int, slot: Int) {
        self.background = SKSpriteNode(
            texture: ElevatorSkin.current.elevatorBackground,
            size: GameScene.elevatorSize
        )
        
        self.overlay = SKSpriteNode(
            texture: ElevatorSkin.current.elevatorOverlay.first,
            size: GameScene.elevatorSize
        )
        
        self.floor = floor
        self.slot = slot
        
        super.init()
        
        self.setupNodes()
    }
    
    fileprivate func setupNodes() {
        self.background.zPosition = ZPosition.elevatorBackground
        self.background.anchorPoint = .init(x: 0.5, y: 0)

        self.addChild(background)
        
        self.overlay.zPosition = ZPosition.elevatorOverlay
        self.overlay.anchorPoint = .init(x: 0.5, y: 0)
        self.addChild(overlay)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension ElevatorNode {
    func open(wait duration: TimeInterval = 0) {
        self.run(
            SKAction.sequence(
                [
                    SKAction.wait(forDuration: duration),
                    SKAction.scale(to: 0.9, duration: GameScene.doorSpeed / 3),
                    SKAction.scale(to: 1.0, duration: GameScene.doorSpeed / 3)
                ]
            )
        )
        
        self.overlay.run(
            SKAction.sequence(
                [
                    SKAction.wait(forDuration: duration),
                    SKAction.animate(
                        with: ElevatorSkin.current.elevatorOverlay,
                        timePerFrame: GameScene.doorSpeed / Double(ElevatorSkin.current.elevatorOverlay.count)
                    ),
                    SKAction.run{
                        self.isOpen = true
                    }
                ]
            )
        )
    }
    
    func close(wait duration: TimeInterval = 0) {
        self.run(
            SKAction.sequence(
                [
                    SKAction.wait(forDuration: duration),
                    SKAction.scale(to: 0.9, duration: GameScene.doorSpeed / 3),
                    SKAction.scale(to: 1.0, duration: GameScene.doorSpeed / 3)
                ]
            )
        )
        
        self.overlay.run(
            SKAction.sequence(
                [
                    SKAction.wait(forDuration: duration),
                    SKAction.animate(
                        with: ElevatorSkin.current.elevatorOverlay.reversed(),
                        timePerFrame: GameScene.doorSpeed / Double(ElevatorSkin.current.elevatorOverlay.count)
                    ),
                    SKAction.run {
                        self.isOpen = false
                    }
                ]
            )
        )
    }
}
