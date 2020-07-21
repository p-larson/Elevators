//
//  PlayerSkin.swift
//  Elevators
//
//  Created by Peter Larson on 4/9/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SpriteKit

public class PlayerSkin {
    
    fileprivate weak var node: PlayerNode? = nil
    
    public static let current = PlayerSkin()
    
    public typealias StringLiteralType = String
        
    private var skins = [String:SKTexture]()
    
    var outfit: PlayerOutfit {
        didSet {
            skins.removeAll()
        }
    }
    
    init(outfit: PlayerOutfit = GameData.outfit) {
        self.outfit = outfit
    }
    
    fileprivate(set) public var state: PlayerState = .idle
    fileprivate(set) public var direction: PlayerDirection =  .right
    
    private var frame = 0
    
    public func nextTexture() -> SKTexture {
        if frame < 14 {
            frame += 1
        } else {
            frame = 1
        }
        
        var name: String!
        
        if outfit.isSymmetric {
            name = "\(outfit.rawValue)-\(state)-\(frame)"
        } else {
            name = "\(outfit.rawValue)-\(state)-\(direction)-\(frame)"
        }
        
        if skins[name] == nil {
            skins[name] = SKTexture(imageNamed: name)
        }
        
        return skins[name]!
    }
    
    func set(direction: PlayerDirection) {
        self.direction = direction
        self.frame = 0
        
        if outfit.isSymmetric {
            if direction == .left {
                self.node?.xScale = -1
            }
                
            else if direction == .right {
                self.node?.xScale = 1
            }
        }
    }
    
    func set(state: PlayerState) {
        self.state = state
        self.frame = 0
    }
    
    func animate(_ target: PlayerNode) {
        self.node = target
        
        node?.run(
            SKAction.repeatForever(
                SKAction.sequence(
                    [
                        SKAction.run {
                            self.node?.texture = self.nextTexture()
                        },
                        SKAction.wait(forDuration: 1.0 / 20.0)
                    ]
                )
            ),
            withKey: "animation"
        )
    }
}
