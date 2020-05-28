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
        background: UIColor(displayP3Red: 130/255, green: 130/255, blue: 130/255, alpha: 1),
        frame: UIColor(displayP3Red: 226/255, green: 226/255, blue: 226/255, alpha: 1),
        door: UIColor(displayP3Red: 205/255, green: 205/255, blue: 205/255, alpha: 1),
        padding: UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1),
        backdrop: UIColor(displayP3Red: 86/255, green: 86/255, blue: 86/255, alpha: 1),
        cable: UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
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
