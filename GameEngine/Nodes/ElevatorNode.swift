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
    
    public var background: SKSpriteNode!
    fileprivate var _overlay: SKSpriteNode!
    
    public var overlay: SKNode {
        get {
            _overlay
        }
    }
    
    let floor: Int, slot: Int, target: Int
    
    public var isOpen: Bool = false
    
    init(floor: Int, slot: Int, target: Int) {
        self.background = SKSpriteNode(
            texture: ElevatorSkin.current.elevatorBackground,
            size: GameScene.elevatorSize
        )
        
        self._overlay = SKSpriteNode(
            texture: ElevatorSkin.current.elevatorOverlay.first,
            size: GameScene.elevatorSize
        )
        
        self.target = target
        self.floor = floor
        self.slot = slot
        
        super.init()
        
        self.setupNodes()
    }
    
    fileprivate func setupNodes() {
        self.background.zPosition = ZPosition.elevatorBackground
        self.background.anchorPoint = .init(x: 0.5, y: 0)

        self.addChild(background)
        
        self._overlay.zPosition = ZPosition.elevatorOverlay
        self._overlay.anchorPoint = .init(x: 0.5, y: 0)
        self.addChild(_overlay)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension ElevatorNode {
    override var description: String {
        return "Elevator Node (\(floor), \(slot))"
    }
}

extension ElevatorNode {
    func open(wait duration: TimeInterval = 0) {
        self._overlay.run(
            SKAction.sequence(
                [
                    SKAction.wait(forDuration: duration),
                    SKAction.scale(to: 1.1, duration: GameScene.doorSpeed / 3),
                    SKAction.scale(to: 1.0, duration: GameScene.doorSpeed / 3)
                ]
            )
        )
        
        self._overlay.run(
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
        self._overlay.run(
            SKAction.sequence(
                [
                    SKAction.wait(forDuration: duration),
                    SKAction.scale(to: 1.1, duration: GameScene.doorSpeed / 3),
                    SKAction.scale(to: 1.0, duration: GameScene.doorSpeed / 3)
                ]
            )
        )
        
        self._overlay.run(
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
