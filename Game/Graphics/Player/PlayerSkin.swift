//
//  PlayerSkin.swift
//  Elevators
//
//  Created by Peter Larson on 4/9/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SpriteKit

public class PlayerSkin: ExpressibleByStringLiteral {
    
    fileprivate weak var node: PlayerNode? = nil
    
    public static var current: PlayerSkin = "orange"
    
    public typealias StringLiteralType = String
    
    private var timer: Timer? = nil
    
    private var skins = [String:SKTexture]()
    
    public let outfit: PlayerOutfit
    
    fileprivate(set) public var state: PlayerState = .idle
    fileprivate(set) public var direction: PlayerDirection =  .right
    
    required public init(stringLiteral value: String) {
        self.outfit = PlayerOutfit(rawValue: value)!
    }
    
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
    
    func animate(_ node: PlayerNode) {
        self.node = node
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 20.0, repeats: true) { (timer) in
            node.texture = self.nextTexture()
        }
    }
}
