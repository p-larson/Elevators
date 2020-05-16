//
//  ElevatorGraphics.swift
//  Elevators
//
//  Created by Peter Larson on 4/7/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

struct Graphics {
    
    static var size = CGSize(width: 180, height: 300)
    
    public static func draw(block: @escaping (CGContext) -> Void) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image(actions: { (context) in
            let cgContext = context.cgContext
            block(cgContext)
            
        })
    }
    
    static func elevatorBackground(style: ElevatorStyle) -> UIImage {
        return Graphics.draw { (context) in
            context.setFillColor(style.background.cgColor)
            context.fill(
                CGRect(x: 0, y: 0, width: size.width, height: size.height - size.height / 8)
            )
            context.setFillColor(style.backdrop.cgColor)
            context.fill(
                CGRect(x: 0, y: size.height - size.height / 8, width: size.width, height: size.height / 5)
            )
            context.clear(
                CGRect(x: 0, y: size.height - size.height / 40, width: size.width, height: size.height / 40)
            )
            context.fill(
                CGRect(x: size.width / 20, y: size.height - size.height / 40, width: size.width * 0.9, height: size.height / 40)
            )
        }
    }
    
    static func elevatorOverlay(style: ElevatorStyle, percent: CGFloat) -> UIImage {
        return Graphics.draw { (context) in
            // Doors
            let space = (size.width / 2) * percent
            let padding = size.width / 50
            // Draw
            context.setFillColor(style.door.cgColor)
            context.fill(CGRect(origin: .zero, size: size))
            context.setFillColor(style.padding.cgColor)
            context.fill(CGRect(x: size.width / 2 - space / 2 - padding, y: 0, width: space + padding * 2, height: size.height))
            context.clear(CGRect(x: size.width / 2 - space / 2, y: 0, width: space, height: size.height))
            // Frame
            context.setStrokeColor(style.frame.cgColor)
            context.setLineWidth(size.width / 8)
            context.addLines(between:
                [.init(x: size.width / 16, y: size.height  - size.width / 16),
                                .init(x: size.width / 16, y: size.width / 16),
                                .init(x: size.width - size.width / 16, y: size.width / 16),
                                .init(x: size.width - size.width / 16, y: size.height - size.width / 16)]
            )
            context.strokePath()
            context.clear(CGRect(x: 0, y: size.height - size.height / 40, width: size.width, height: size.height / 20))
        }
    }
}
