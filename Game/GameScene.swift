//
//  GameScene.swift
//  Elevators
//
//  Created by Peter Larson on 4/19/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SpriteKit

final public class GameScene: SKScene {
    // Model
    let floors: Int
    let elevatorModels: [ElevatorModel]
    // Data
    var currentFloor: Int = 1
    let playerNode = PlayerNode()
    // Player ---
    
    init(floors: Int, elevators: [ElevatorModel]) {
        self.floors = floors
        self.elevatorModels = elevators
        super.init(size: UIScreen.main.bounds.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

// Game Data
extension GameScene {
    var elevatorNodes: [ElevatorNode] {
        children.compactMap { (node) -> ElevatorNode? in
            node as? ElevatorNode
        }
    }
    
    func elevators(on floor: Int) -> [ElevatorModel] {
        elevatorModels.filter { (model) -> Bool in
            model.floor == floor || model.target == floor
        }.sorted { (e1, e2) -> Bool in
            e1.floor < e2.floor
        }
    }
    
    func elevator(at slot: Int, on floor: Int) -> ElevatorModel? {
        elevators(on: floor).first { (model) -> Bool in
            model.slot == slot
        }
    }
    
    func playerElevator() -> ElevatorModel? {
        elevator(at: playerNode.slot, on: playerNode.floor)
    }
    
    var floorNodes: [FloorNode] {
        children.compactMap { (child) -> FloorNode? in
            child as? FloorNode
        }.sorted { (f1, f2) -> Bool in
            f1.floor < f2.floor
        }
    }
    
    func floorNode(at floor: Int) -> FloorNode? {
        floorNodes.first { (floorNode) -> Bool in
            floorNode.floor == floor
        }
    }
}

extension GameScene {
    public override func didMove(to view: SKView) {
        self.render()
        self.setupPlayer()
        self.setupSwipes()
    }
}

extension GameScene {
    static var maxSlot: Int { slots - 1 }
    static let slots: Int = 5
    static let maxFloorsShown: CGFloat = 8
    static let floorSpeed: TimeInterval = 0.25
    static let playerSpeed: TimeInterval = 0.5
    static let doorSpeed: TimeInterval = 0.1
    static let elevatorSpace: CGFloat = 20.0
    static var validSlots: Range<Int> {
        0 ..< slots
    }
}

// Size
extension GameScene {
    static var floorSize: CGSize {
        return CGSize(
            width: UIScreen.main.bounds.size.width,
            height: UIScreen.main.bounds.size.height / GameScene.maxFloorsShown
        )
    }
    
    static var floorBaseSize: CGSize {
        return CGSize(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.size.height / GameScene.maxFloorsShown / 8
        )
    }
    
    static var floorWallPaperSize: CGSize {
        return CGSize(
            width: UIScreen.main.bounds.size.width,
            height: (GameScene.floorSize.height - GameScene.floorBaseSize.height)
        )
    }
    
    static var elevatorSize: CGSize {
        return CGSize(
            width: (GameScene.floorSize.height - GameScene.floorBaseSize.height) * (9/15),
            height: (GameScene.floorSize.height - GameScene.floorBaseSize.height)
        ).applying(.init(scaleX: 0.7, y: 0.7))
    }
    
    static var playerSize: CGSize {
        return CGSize(
            width: (GameScene.floorSize.height - GameScene.floorBaseSize.height) * (9/15),
            height: (GameScene.floorSize.height - GameScene.floorBaseSize.height)
        ).applying(.init(scaleX: 0.6, y: 0.6))
    }
    
    static var slotWidth: CGFloat {
        return elevatorSize.width + 20.0
    }
    
    static var bottomSpace: CGFloat {
        return UIScreen.main.bounds.size.height / 7
    }
    
    static func cableSize(of length: Int) -> CGSize {
        return CGSize(
            width: elevatorSize.width / 5,
            height: floorSize.height * CGFloat(length)
        )
    }
}

fileprivate extension GameScene {
    func elevatorXPosition(at slot: Int) -> CGFloat {
        var x: CGFloat = 0
        
        x += GameScene.floorSize.width / 2
        x -= (CGFloat(GameScene.slots) / 2) * GameScene.elevatorSize.width
        x -= (CGFloat(GameScene.slots / 2)) * GameScene.elevatorSpace
        
        x += GameScene.elevatorSize.width / 2
        x += GameScene.elevatorSize.width * CGFloat(slot)
        x += GameScene.elevatorSpace * CGFloat(slot)
        
        return x
    }
    
    func elevatorYPosition(at floor: Int) -> CGFloat {
        var y: CGFloat = 0
        
        y += GameScene.bottomSpace + GameScene.floorBaseSize.height
        y -= GameScene.floorSize.height
        y += GameScene.floorSize.height * CGFloat(floor)
        y += self.currentFloorOffset
        
        return y
    }
}

// Rendering Floors
fileprivate extension GameScene {
    
    var maxElevatorDistance: Int {
        return elevatorModels.map { $0.distance }.max()!
    }
    
    var validFloors: ClosedRange<Int> {
        return 1 ... floors
    }
    
    var rendered: Range<Int> {
        return currentFloor - maxElevatorDistance ..< currentFloor + Int(GameScene.maxFloorsShown.rounded(.up))
    }
    
    var loaded: Range<Int> {
        return rendered.lowerBound ..< rendered.upperBound + maxElevatorDistance
    }
    
    func load(model: ElevatorModel) {
        do {
            let destination = ElevatorNode(model: model, isOrigin: false)
            
            destination.position.y = elevatorYPosition(at: model.target)
            destination.position.x = elevatorXPosition(at: model.slot)
            
            model.destination = destination
            
            self.addChild(destination)
        }
        
        do {
            let origin = ElevatorNode(model: model, isOrigin: true)
            
            origin.position.y = elevatorYPosition(at: model.floor)
            origin.position.x = elevatorXPosition(at: model.slot)
            
            model.origin = origin
            
            self.addChild(origin)
        }
        
        do {
            let cable = CableNode(length: model.distance)
            
            cable.position.y = elevatorYPosition(at: model.floor)
            cable.position.x = elevatorXPosition(at: model.slot)
            
            self.addChild(cable)
        }
    }
    
    func load(_ floor: Int) {
        let node = FloorNode(floor: floor)
        self.addChild(node)
    }
    
    var currentFloorOffset: CGFloat {
        let distance = CGFloat(rendered.lowerBound - currentFloor)
        
        return distance * GameScene.floorSize.height
    }
    
    func render() {
        // Load elevators
        for model in elevatorModels where loaded.contains(model.floor) {
            if model.destination == nil && model.origin == nil {
                self.load(model: model)
            } else if let topNode = model.topNode, let bottomNode = model.bottomNode {
                // Update elevator y positions
                topNode.position.y = elevatorYPosition(at: model.top)
                bottomNode.position.y = elevatorYPosition(at: model.bottom)
            }
        }
        // Load floors
        for floor in rendered where validFloors.contains(floor) {
            if floorNode(at: floor) == nil {
                self.load(floor)
            }
        }
        
        self.vStack(
            children: floorNodes,
            spacing: 0,
            totalOffset:
            GameScene.bottomSpace + currentFloorOffset,
            print: true
        )
    }
    // Remove any floor or elevator that is shouldn't be rendered
    func clean() {
        for model in elevatorModels where !loaded.contains(model.floor) {
            model.destination?.removeFromParent()
            model.origin?.removeFromParent()
        }
    }
}

// Changing current floor
extension GameScene {
    func set(floor: Int) {
        self.currentFloor = floor
        self.render()
        // Move camera then after move, dealocate
    }
}

// Player
extension GameScene {
    func setupPlayer() {
        // Setup x Position
        if let first = self.elevators(on: 1).first {
            playerNode.slot = first.slot
        }
        
        playerNode.position.x = self.elevatorXPosition(at: playerNode.slot)
        playerNode.position.y = self.playerYPosition()
        
        self.addChild(playerNode)
    }
    
    func playerYPosition() -> CGFloat {
        var y: CGFloat = -3.25 // Images have a weird spacing, needs to be removed in final builds
        
        y += GameScene.bottomSpace + GameScene.floorBaseSize.height
        y -= GameScene.floorSize.height
        y += GameScene.floorSize.height * CGFloat(playerNode.floor)
        
        return y
    }
}

protocol MoveHandler {
    func right()
    func left()
    func send()
    func `return`()
}

extension GameScene: MoveHandler {
    func right() {
        guard !playerNode.isInsideElevator else {
            return
        }
        
        var range = (playerNode.slot ..< GameScene.slots)
        
        if range.isEmpty == false {
            range.removeFirst()
        }
        
        for slot in range {
            if elevator(at: slot, on: playerNode.floor) != nil {
                // Move player
                self.playerNode.right()
                PlayerSkin.current.set(state: .run)
            }
        }
    }
    
    func left() {
        
        guard !playerNode.isInsideElevator else {
            return
        }
        
        var range = (0 ..< playerNode.slot)
        
        if range.isEmpty == false {
            range.removeLast()
        }
        
        for slot in range {
            if elevator(at: slot, on: playerNode.floor) != nil {
                // Move player
                self.playerNode.left()
                PlayerSkin.current.set(state: .run)
            }
        }
    }
    
    @objc func send() {
        guard !playerNode.isInsideElevator, let elevatorModel = playerElevator(), playerNode.floor == elevatorModel.bottom, let currentElevator = elevatorModel.bottomNode, let targetElevator = elevatorModel.topNode else {
            return
        }
        
        /*
         
         1. open doors/player enter
         2. close doors
         3. move camera
         4. update player location, re-render.
         5. open doors/player exit
         
         */
        
        let cameraSpeed: TimeInterval = Double(abs(elevatorModel.distance)) * GameScene.floorSpeed
        
        PlayerSkin.current.set(state: .idle)
        
        self.run(
            .sequence(
                [
                    SKAction.run(duration: GameScene.doorSpeed) {
                        self.playerNode.enter()
                        currentElevator.open()
                    },
                    SKAction.run(duration: GameScene.doorSpeed) {
                        currentElevator.close()
                    },
                    SKAction.run(duration: cameraSpeed) {
                        self.camera?.run(
                            SKAction.moveBy(
                                x: 0,
                                y: self.cameraYTranslation(
                                    distance: elevatorModel.distance),
                                duration: cameraSpeed
                            )
                        )
                    },
                    SKAction.run {
                        self.currentFloor = elevatorModel.top
                        self.playerNode.position.y = self.playerYPosition()
                        self.render()
                        self.clean()
                    },
                    SKAction.run(duration: GameScene.doorSpeed) {
                        targetElevator.open()
                    },
                    SKAction.run(duration: GameScene.doorSpeed) {
                        self.playerNode.exit()
                        targetElevator.close()
                    },
                    SKAction.run {
                        print("finished")
                    }
                ]
            )
        )
    }
    
    @objc func `return`() {
        guard !playerNode.isInsideElevator, let elevator = playerElevator(), playerNode.floor == elevator.top else {
            return
        }
        
        
        
    }
}

extension GameScene {
    func setupSwipes() {
        let up = UISwipeGestureRecognizer(target: self, action: #selector(self.send))
        
        up.direction = .up
        
        view?.addGestureRecognizer(up)
        
        let down = UISwipeGestureRecognizer(target: self, action: #selector(self.return))
        
        down.direction = .down
        
        view?.addGestureRecognizer(down)
    }
}

extension GameScene {
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            touch.location(in: self).x < frame.midX ? left():right()
        }
    }
}

// Camera
extension GameScene {
    
    var cameraOrigin: CGPoint {
        .init(
            x: frame.midX,
            y: frame.midY
        )
    }
    
    func cameraYTranslation(distance: Int) -> CGFloat {
        return CGFloat(distance) * GameScene.floorSize.height
    }
    
    func setupCamera() {
        let camera = SKCameraNode()
        
        camera.position = cameraOrigin
        
        self.camera = camera
    }
}


import SwiftUI

struct GameScene_Previews: PreviewProvider {
    static var previews: some View {
        GameView_Previews.previews
    }
}

extension GameScene {
    // debugging
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            //            print(touch.location(in: self))
        }
    }
}
