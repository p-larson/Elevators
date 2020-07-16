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
    fileprivate(set) var direction: PlayerDirection = .right
    
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
    
    func set(direction: PlayerDirection) {
        if self.direction != direction || !isMoving && !isInsideElevator {
            move(direction: direction)
        }
    }
    
    var isMoving: Bool {
        action(forKey: "move") != nil
    }
    
    func stopMoving() {
        self.removeAction(forKey: "move")
        PlayerSkin.current.set(state: .idle)
    }
    
    var right: [Int] {
        (slot - GameScene.maxSlot) == 0 ? [] : Array(min(slot + 1, GameScene.maxSlot) ..< GameScene.slots)
    }
    
    var left: [Int] {
        Array(0 ..< slot).reversed() as [Int]
    }
    
    var closestSlot: Int {
        guard let gc = gamescene else {
            return slot
        }
        
        return (0 ..< GameScene.slots).map { abs(gc.elevatorXPosition(at: $0) - position.x) }.enumerated().min {
            e1, e2 in
            
            return e1.element < e2.element
        }?.offset ?? slot
    }
    
    var nextSlot: Int {
        if direction == .right {
            return min(slot + 1, GameScene.maxSlot)
        } else {
            return max(slot - 1, 0)
        }
    }
    
    func direciton(to slot: Int) -> PlayerDirection {
        guard let gc = gamescene else {
            return direction
        }
        
        let slotX = gc.elevatorXPosition(at: slot)
        
        if slotX > position.x {
            return PlayerDirection.right
        } else {
            return PlayerDirection.left
        }
    }
    
    func center() -> TimeInterval {
        guard let gc = gamescene else {
            return 0
        }
        
        self.removeAction(forKey: "center")
        
        // slot = nextSlot
        
        PlayerSkin.current.set(state: .run)
        PlayerSkin.current.set(direction: direciton(to: slot))
        
        let targetX = gc.elevatorXPosition(at: slot)
        let deltaX = Double(targetX - position.x)
        let duration: TimeInterval = (GameScene.playerSpeed * abs(deltaX)) / Double(gc.slotWidth)
        let completion = {
            PlayerSkin.current.set(state: .idle)
        }
        
        let move = SKAction.sequence([SKAction.moveTo(x: targetX, duration: duration), SKAction.run(completion)])
        
        self.run(move, withKey: "center")
        
        return duration
    }
    
    var isCentering: Bool {
        action(forKey: "center") != nil
    }
    
    func stopCentering() {
        removeAction(forKey: "center")
    }
    
    // Move in the
    func move(direction: PlayerDirection) {
        guard let gc = gamescene else {
            return
        }
        
        let targetSlot = direction == .right ? GameScene.maxSlot : 0
        
        PlayerSkin.current.set(direction: direction)
        
        // No Movement needed.
        guard targetSlot != slot else {
            return
        }
        
        self.stopCentering()
        
        self.direction = direction
        
        PlayerSkin.current.set(state: .run)
        
        let targetX = gc.elevatorXPosition(at: targetSlot)
        let deltaX = Double(targetX - position.x)
        let duration: TimeInterval = (GameScene.playerSpeed * abs(deltaX)) / Double(gc.slotWidth)
        let completion = {
            PlayerSkin.current.set(state: .idle)
        }
        
        let move = SKAction.sequence([SKAction.moveTo(x: targetX, duration: duration), SKAction.run(completion)])

        let path = direction == .right ? self.right : self.left
        
        let timing: [(Int, TimeInterval)] = path.enumerated().map { (index, nextSlot) in
            if index == 0 {
                let targetX = gc.elevatorXPosition(at: nextSlot)
                let deltaX = Double(targetX - position.x)
                return (nextSlot, (GameScene.playerSpeed * abs(deltaX)) / Double(gc.slotWidth))
            } else {
                return (nextSlot, GameScene.playerSpeed)
            }
        }
        
        let slotChangeClock: [SKAction] = timing.map { nextSlot, duration in
            SKAction.sequence(
                [
                    SKAction.run {
                        self.slot = nextSlot
                        self.gamescene?.updateTarget()
                    },
                    SKAction.wait(forDuration: duration)
                ]
            )
        }
        
        self.run(SKAction.group([SKAction.sequence(slotChangeClock), move]), withKey: "move")
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
}
