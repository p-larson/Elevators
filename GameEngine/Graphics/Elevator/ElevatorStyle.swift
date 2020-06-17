//
//  ElevatorStyle.swift
//  Elevators
//
//  Created by Peter Larson on 4/7/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import UIKit
import SpriteKit

public struct ElevatorStyle {
    let background: UIColor
    let frame: UIColor
    let door: UIColor
    let padding: UIColor
    let backdrop: UIColor
    let cable: UIColor
    
    public init(background: UIColor, frame: UIColor, door: UIColor, padding: UIColor, backdrop: UIColor, cable: UIColor) {
        self.background = background
        self.frame = frame
        self.door = door
        self.padding = padding
        self.backdrop = backdrop
        self.cable = cable
    }
    
    static let demo = ElevatorStyle(
        background: #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1),
        frame: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1),
        door: #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.8039215686, alpha: 1),
        padding: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1),
        backdrop: #colorLiteral(red: 0.2588414634, green: 0.2745807927, blue: 0.3003810976, alpha: 1),
        cable: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    )
    
    static let locked = ElevatorStyle(
        background: .black,
        frame: .black,
        door: .black,
        padding: .black,
        backdrop: .black,
        cable: .black
    )
    
    static var random: ElevatorStyle {
        return ElevatorStyle(
            background: .random,
            frame: .random,
            door: .random,
            padding: .random,
            backdrop: .random,
            cable: .random
        )
    }
}
