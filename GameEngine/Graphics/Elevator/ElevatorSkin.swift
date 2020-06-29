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
    // GameScene.doorSpeed * FRAMES_PER_SECOND
    public var doorFrames: [SKTexture]!
    // GameScene.waveSpeed * FRAMES_PER_SECOND
    public var waveFrames: [SKTexture]!
    
    // For Animations
    static let FRAMES_PER_SECONDS = 60
    
    static var doorFramesCount: Int {
        return Int((TimeInterval(ElevatorSkin.FRAMES_PER_SECONDS) * GameScene.doorSpeed).rounded(.up))
    }
    
    static var waveFramesCount: Int {
        return Int((TimeInterval(ElevatorSkin.FRAMES_PER_SECONDS) * GameScene.waveSpeed).rounded(.up))
    }
    
    private init() {
        // Look up preferences
        elevatorStyle = save.object(forKey: "elevator-style") as? ElevatorStyle ?? ElevatorStyle.demo
        
        elevatorBackground = SKTexture(image: Graphics.elevatorBackground(style: elevatorStyle))
        
        // # frames =
        print("Generating", ElevatorSkin.doorFramesCount, "door frames.")
        doorFrames = (1 ... ElevatorSkin.doorFramesCount).map { frame in
            return SKTexture(
                image: Graphics.elevatorOverlay(
                    style: self.elevatorStyle,
                    percent: CGFloat(frame) / CGFloat(ElevatorSkin.doorFramesCount)
                )
            )
        }
        print("Generating", ElevatorSkin.waveFramesCount, "wave frames.")
        waveFrames = (1 ... ElevatorSkin.waveFramesCount).map { frame in
            return SKTexture(
                image: Graphics.elevatorOverlay(
                    style: self.elevatorStyle,
                    percent: CGFloat(frame) / CGFloat(ElevatorSkin.waveFramesCount)
                )
            )
        }

    }
}
