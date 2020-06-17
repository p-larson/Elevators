//
//  Stack.swift
//  Elevators
//
//  Created by Peter Larson on 4/19/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode {
    func vStack(children: [SKNode], spacing: CGFloat = 0, totalOffset: CGFloat = 0) {
        var offset: CGFloat = totalOffset
        
        children.enumerated().forEach { (index, child) in
            child.position.y = offset
            
            offset += child.absoluteSpriteHeight + spacing
        }
    }
    
    func hStack(children: [SKNode], spacing: CGFloat = 0, totalOffset: CGFloat = 0) {
        var offset: CGFloat = 0
        
        children.forEach { (child) in
            offset += child.calculateAccumulatedFrame().width / 2
            child.position.x = offset
        }
    }
}

extension SKNode {
    
    var absoluteSpriteHeight: CGFloat {
        var height: CGFloat = (self as? SKSpriteNode)?.size.height ?? 0
        
        children.forEach { (child) in
            height += child.absoluteSpriteHeight
        }
        
        return height
    }
}
