//
//  UIColor+Random.swift
//  Elevators
//
//  Created by Peter Larson on 5/20/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        UIColor(
            displayP3Red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
