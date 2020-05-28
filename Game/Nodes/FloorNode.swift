//
//  FloorNode.swift
//  Elevators
//
//  Created by Peter Larson on 4/19/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SpriteKit

public class FloorNode: SKNode {
    let floor: Int
    
    private var base: SKSpriteNode!
    private var wallpaper: SKSpriteNode!
    
    private static let baseTexture: SKTexture = SKTexture(image: Graphics.base())
    private static let finish: SKTexture = SKTexture(image: Graphics.finishLine())
    
    init(floor: Int, isFinal: Bool) {
        self.floor = floor
        super.init()
        
        do {
            self.base = SKSpriteNode(texture: FloorNode.baseTexture, size: GameScene.floorBaseSize)
            self.base.anchorPoint = .zero
            self.base.position.x = 16
            self.base.zPosition = ZPosition.floorBase
            self.addChild(base)
        }
        
        
        if isFinal {
            let node = SKSpriteNode(texture: FloorNode.finish, size: GameScene.finishLineSize)
            
            node.position.y += GameScene.floorBaseSize.height
            node.position.y += GameScene.elevatorSize.height / 2
            node.position.x = GameScene.finishLineSize.width / 2
            node.alpha = 1.0
            node.zPosition = ZPosition.floorWallpaper
            
            self.addChild(node)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
