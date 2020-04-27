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
    
    public var isOpen: Bool = false
    public let isOrigin: Bool
    
    weak var model: ElevatorModel? = nil
    
    init(model: ElevatorModel, isOrigin: Bool) {
        self.background = SKSpriteNode(texture: ElevatorSkin.current.elevatorBackground, size: GameScene.elevatorSize)
        self.overlay = SKSpriteNode(texture: ElevatorSkin.current.elevatorOverlay.first, size: GameScene.elevatorSize)
        self.model = model
        self.isOrigin = isOrigin
        super.init()
        
        // Setup nodes
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
    func open() {
        self.run(
            SKAction.sequence(
                [
                    SKAction.animate(
                        with: ElevatorSkin.current.elevatorOverlay,
                        timePerFrame: Double(ElevatorSkin.current.elevatorOverlay.count) / 20.0
                    ),
                    SKAction.run{
                        self.isOpen = true
                    }
                ]
            )
        )
    }
    
    func close() {
        self.run(
            SKAction.sequence(
                [
                    SKAction.animate(
                        with: ElevatorSkin.current.elevatorOverlay.reversed(),
                        timePerFrame: Double(ElevatorSkin.current.elevatorOverlay.count) / 20.0
                    ),
                    SKAction.run {
                        self.isOpen = false
                    }
                ]
            )
        )
    }
}
