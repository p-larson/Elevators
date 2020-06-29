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
    
    var frameNumber = 0
    
    public var isOpen: Bool = false, isEnabled = true
    
    init(floor: Int, slot: Int, target: Int) {
        self.background = SKSpriteNode(
            texture: ElevatorSkin.current.elevatorBackground,
            size: GameScene.elevatorSize
        )
        
        self._overlay = SKSpriteNode(
            texture: ElevatorSkin.current.doorFrames.first!,
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

/*
 
 player starts floor = open all, slowly close with kill speed.
 player picks an elevator = cancel, open time it takes, then close all from spot normal timing.
 
 */

// Opening/Closing
extension ElevatorNode {
    
    fileprivate func stopAnimations() {
        self.removeAction(forKey: "open")
        self.removeAction(forKey: "close")
    }
    
    fileprivate func _close(duration: TimeInterval, textures: [SKTexture]) -> TimeInterval {
        
        // Stop current animations
        self.stopAnimations()
        
        var convertedFrame = Int((Double(self.frameNumber) / Double(ElevatorSkin.doorFramesCount)) * Double(textures.count))
        let fps = duration / Double(textures.count)
        
        guard convertedFrame != 0 else {
            return 0
        }
        
        // Get number of frames
        
        let frameUpdate: SKAction = .run {
            convertedFrame -= 1
            self.frameNumber = Int(Double(convertedFrame * ElevatorSkin.doorFramesCount) / Double(textures.count))
            self._overlay.texture = textures[convertedFrame]
        }
        
        let count = convertedFrame
        
        let delay: SKAction = .wait(forDuration: fps)
        
        let loop: SKAction = .repeat(.sequence([delay, frameUpdate]), count: count)
        
        let exit: SKAction = .run {
            self.isOpen = false
        }
                
        self.run(.sequence([loop, exit]), withKey: "close")
        
        return TimeInterval(count) * fps
    }
    
    // Return the time it takes to complete
    @discardableResult func waveClose() -> TimeInterval {
        _close(duration: GameScene.waveSpeed, textures: ElevatorSkin.current.waveFrames)
    }

    @discardableResult func close() -> TimeInterval {
        _close(duration: GameScene.doorSpeed, textures: ElevatorSkin.current.doorFrames)
    }
    
    // Try to open
    func open() {
        self.stopAnimations()
        
        let fps: TimeInterval = GameScene.doorSpeed / TimeInterval(ElevatorSkin.doorFramesCount)
        let updateFrame: SKAction = .sequence(
            [
                SKAction.wait(forDuration: fps),
                SKAction.run({
                    self._overlay.texture = ElevatorSkin.current.doorFrames[self.frameNumber]
                    self.frameNumber += 1
                })
            ]
        )
        
        let exit: SKAction = .run {
            self.isOpen = true
        }
        
        let count: Int = ElevatorSkin.current.doorFrames.count - self.frameNumber
        
        self.run(SKAction.sequence([SKAction.repeat(updateFrame, count: count), exit]), withKey: "open")
    }
}

extension ElevatorNode {
    func shimmy() {
        self.run(
            SKAction.sequence(
                [
                    SKAction.moveBy(x: 0, y: self.overlay.frame.height / 10, duration: 0.1),
                    SKAction.moveBy(x: 0, y: -self.overlay.frame.height / 10, duration: 0.1)
                ]
            ).with(timing: SKActionTimingMode.easeInEaseOut)
        )
    }
    
    func disable() {
        self.run(
            SKAction.fadeAlpha(to: 0.8, duration: 0.1)
        )
    }
}
