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
    
    init(floor: Int) {
        self.floor = floor
        super.init()
        
        do {
            self.base = SKSpriteNode(color: .black, size: GameScene.floorBaseSize)
            self.base.anchorPoint = .zero
            self.base.zPosition = ZPosition.floorBase
            self.addChild(base)
            self.wallpaper = SKSpriteNode(color: .lightGray, size: GameScene.floorWallPaperSize)
            self.wallpaper.anchorPoint = .zero
            self.wallpaper.zPosition = ZPosition.floorWallpaper
            self.addChild(wallpaper)
            self.vStack(children: [base, wallpaper], print: true)
        }
        
        do {
            let node = SKLabelNode()
            
            node.text = floor.description
            node.fontColor = .black
            node.position.y = GameScene.floorSize.height / 2
            node.position.x = GameScene.floorSize.width / 2
            
            self.addChild(node)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
