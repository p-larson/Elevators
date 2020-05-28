//
//  Graphics.swift
//  Elevators
//
//  Created by Peter Larson on 4/7/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

fileprivate let LOW_GRAPHIC = CGAffineTransform(scaleX: 0.25, y: 0.25)

struct Graphics {
        
    static let elevatorSize = CGSize(width: 180, height: 300) // Good Resolution, I suppose.
    
    public static func draw(size: CGSize, block: @escaping (CGContext) -> Void) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image(actions: { (context) in
            let cgContext = context.cgContext
            block(cgContext)
            
        })
    }
    
    static func wallpaper() -> UIImage {
        return Graphics.draw(size: GameScene.floorWallPaperSize.applying(LOW_GRAPHIC)) { (context) in
            context.setFillColor(UIColor.lightGray.cgColor)
            context.fill(
                CGRect(origin: .zero, size: GameScene.floorWallPaperSize)
            )
        }
    }
    
    static func base() -> UIImage {
        return Graphics.draw(size: GameScene.floorBaseSize) { (context) in
            
            context.setFillColor(CGColor(srgbRed: 229/255, green: 252/255, blue: 242/255, alpha: 1.0))
            
            let rect = CGRect(origin: .zero, size: GameScene.floorBaseSize)
            
            context.addPath(
                UIBezierPath(roundedRect: rect, cornerRadius: rect.height / 2).cgPath
            )
            
            context.fillPath()
        }
    }
    
    static func elevatorBackground(style: ElevatorStyle) -> UIImage {
        return Graphics.draw(size: Graphics.elevatorSize) { (context) in
            context.setFillColor(style.background.cgColor)
            context.fill(
                CGRect(x: 0, y: 0, width: Graphics.elevatorSize.width, height: Graphics.elevatorSize.height - Graphics.elevatorSize.height / 8)
            )
            context.setFillColor(style.backdrop.cgColor)
            context.fill(
                CGRect(x: 0, y: Graphics.elevatorSize.height - Graphics.elevatorSize.height / 8, width: Graphics.elevatorSize.width, height: Graphics.elevatorSize.height / 5)
            )
            context.clear(
                CGRect(x: 0, y: Graphics.elevatorSize.height - Graphics.elevatorSize.height / 40, width: Graphics.elevatorSize.width, height: Graphics.elevatorSize.height / 40)
            )
            context.fill(
                CGRect(x: Graphics.elevatorSize.width / 20, y: Graphics.elevatorSize.height - Graphics.elevatorSize.height / 40, width: Graphics.elevatorSize.width * 0.9, height: Graphics.elevatorSize.height / 40)
            )
        }
    }
    
    static func elevatorOverlay(style: ElevatorStyle, percent: CGFloat) -> UIImage {
        return Graphics.draw(size: Graphics.elevatorSize) { (context) in
            // Doors
            let space = (Graphics.elevatorSize.width / 5 * 4) * percent
            let padding = Graphics.elevatorSize.width / 50
            // Draw
            context.setFillColor(style.door.cgColor)
            context.fill(CGRect(origin: .zero, size: Graphics.elevatorSize))
            context.setFillColor(style.padding.cgColor)
            context.fill(CGRect(x: Graphics.elevatorSize.width / 2 - space / 2 - padding, y: 0, width: space + padding * 2, height: Graphics.elevatorSize.height))
            context.clear(CGRect(x: Graphics.elevatorSize.width / 2 - space / 2, y: 0, width: space, height: Graphics.elevatorSize.height))
            // Frame
            context.setStrokeColor(style.frame.cgColor)
            context.setLineWidth(Graphics.elevatorSize.width / 8)
            context.addLines(between:
                [.init(x: Graphics.elevatorSize.width / 16, y: Graphics.elevatorSize.height  - Graphics.elevatorSize.width / 16),
                                .init(x: Graphics.elevatorSize.width / 16, y: Graphics.elevatorSize.width / 16),
                                .init(x: Graphics.elevatorSize.width - Graphics.elevatorSize.width / 16, y: Graphics.elevatorSize.width / 16),
                                .init(x: Graphics.elevatorSize.width - Graphics.elevatorSize.width / 16, y: Graphics.elevatorSize.height - Graphics.elevatorSize.width / 16)]
            )
            context.strokePath()
            context.clear(CGRect(x: 0, y: Graphics.elevatorSize.height - Graphics.elevatorSize.height / 40, width: Graphics.elevatorSize.width, height: Graphics.elevatorSize.height / 20))
        }
    }
    
    static func finishLine() -> UIImage {
        return Graphics.draw(size: GameScene.finishLineSize) { (context) in
            // Checkered finish line
            let checkerSize = GameScene.finishLineSize.applying(.init(scaleX: 1.0 / 16.0, y: 0.5))
            var whites = [CGRect](), blacks = [CGRect]()
            
            for number in 0 ..< 32 {
                let x = CGFloat(number % 16) * checkerSize.width
                let y = CGFloat(number / 16) * checkerSize.height
                
                let rect = CGRect(x: x, y: y, width: checkerSize.width, height: checkerSize.height)
                
                if (number + (number / 16)) % 2 == 0 {
                    whites.append(rect)
                } else {
                    blacks.append(rect)
                }
            }
            context.setFillColor(UIColor.white.cgColor)
            context.fill(whites)
            context.setFillColor(UIColor.black.cgColor)
            context.fill(blacks)
        }
    }
    
    static func cry() -> UIImage {
        
        let size = CGSize(width: 25, height: 25)
        
        return Graphics.draw(size: size) { (context) in
            let layer = CATextLayer()
            
            layer.frame = CGRect(origin: .zero, size: size)
            
            layer.fontSize = 20
            layer.string = "😭"
            layer.alignmentMode = .center
            
            layer.draw(in: context)
        }
    }
}
