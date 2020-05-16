//
//  SKAction.swift
//  Elevators
//
//  Created by Peter Larson on 4/22/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SpriteKit

extension SKAction {
    static func run(duration: TimeInterval, block: @escaping () -> Void) -> SKAction {
        SKAction.sequence(
            [
                SKAction.run(block), SKAction.wait(forDuration: duration)
            ]
        )
    }
}
