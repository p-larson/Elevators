//
//  ElevatorSkin.swift
//  Elevators
//
//  Created by Peter Larson on 4/19/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SpriteKit

fileprivate let save = UserDefaults()

public class ElevatorSkin {
    private(set) public static var current = ElevatorSkin()
    
    private(set) public var elevatorStyle: ElevatorStyle
    
    public var elevatorBackground: SKTexture!
    public var elevatorOverlay: [SKTexture]!
    
    private init() {
        // Look up preferences
        elevatorStyle = save.object(forKey: "elevator-style") as? ElevatorStyle ?? ElevatorStyle.demo
        
        elevatorBackground = SKTexture(image: Graphics.elevatorBackground(style: elevatorStyle))
        elevatorOverlay = (1 ... 20).map { frame in
            return SKTexture(
                image: Graphics.elevatorOverlay(
                    style: self.elevatorStyle,
                    percent: CGFloat(frame) / CGFloat(20)
                )
            )
        }

    }
}
