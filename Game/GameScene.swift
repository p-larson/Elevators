//
//  GameScene.swift
//  Elevators
//
//  Created by Peter Larson on 4/19/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SpriteKit

final public class GameScene: SKScene, ObservableObject {
    // Model
    let model: LevelModel
    // Data
    let playerNode = PlayerNode(floor: 1)
    var didSucceedLongTouch = false
    var isTouching = false
    // State
    @Published var hasEnded: Bool = false
    @Published var hasWon: Bool = false
    
    init(model: LevelModel) {
        self.model = model
        
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
    
    func elevatorNodes(on floor: Int) -> [ElevatorNode] {
        elevatorNodes.filter { (node) -> Bool in
            node.floor == floor
        }
    }
    
    func originNode(for elevator: ElevatorModel) -> ElevatorNode? {
        elevatorNodes.first { (elevatorNode) -> Bool in
            elevator.floor == elevatorNode.floor && elevator.slot == elevatorNode.slot
        }
    }
    
    func targetNode(for elevator: ElevatorModel) -> ElevatorNode? {
        elevatorNodes.first { (elevatorNode) -> Bool in
            elevator.target == elevatorNode.floor && elevator.slot == elevatorNode.slot
        }
    }
    
    func elevators(on floor: Int) -> [ElevatorModel] {
        model.elevators.filter { (elevator) -> Bool in
            elevator.floor == floor || elevator.target == floor
        }.sorted { (e1, e2) -> Bool in
            e1.floor < e2.floor
        }
    }
    
    func elevator(at slot: Int, on floor: Int) -> ElevatorModel? {
        elevators(on: floor).first { (elevator) -> Bool in
            elevator.slot == slot
        }
    }
    
    func coin(for model: CoinModel) -> CoinNode? {
        coinNodes.first { (node) -> Bool in
            node.model == model
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
    
    var cableNodes: [CableNode] {
        children.compactMap { (child) -> CableNode? in
            child as? CableNode
        }
    }
    
    var coinNodes: [CoinNode] {
        children.compactMap { (child) -> CoinNode? in
            child as? CoinNode
        }
    }
}

extension GameScene {
    public override func sceneDidLoad() {
        self.render()
        self.clean()
        self.setupPlayer()
        self.setupCamera()
        self.startWave()
        print("Loading Scene. \(model.slots) Slots, \(model.floors) Floors, \(model.elevators.count) Elevators, \(model.coins.count) Coins.")
    }
}

extension GameScene {
    var maxSlot: Int {
        model.slots - 1
    }
    
    var validSlots: Range<Int> {
        0 ..< model.slots
    }
}

extension GameScene {
    static let maxFloorsShown: CGFloat = 8
    static let floorSpeed: TimeInterval = 0.5
    static let playerSpeed: TimeInterval = 0.3
    static let doorSpeed: TimeInterval = 0.3
    static let waveSpeed: TimeInterval = 3.0
    static let cameraSpeed: TimeInterval = 0.25
    static let elevatorSpace: CGFloat = 20.0
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
    
    static var coinSize: CGSize {
        return CGSize(
            width: (GameScene.playerSize.width / 2),
            height: (GameScene.playerSize.width / 2)
        )
    }
    
    static var slotWidth: CGFloat {
        return elevatorSize.width + 20.0
    }
    
    static var bottomSpace: CGFloat {
        return UIScreen.main.bounds.size.height / 4
    }
    
    static func cableSize(of length: Int) -> CGSize {
        return CGSize(
            width: elevatorSize.width / 5,
            height: floorSize.height * CGFloat(length)
        )
    }
}

public extension GameScene {
    func elevatorXPosition(at slot: Int) -> CGFloat {
        var x: CGFloat = 0
        
        x += GameScene.floorSize.width / 2
        x -= (CGFloat(self.model.slots) / 2) * GameScene.elevatorSize.width
        x -= (CGFloat(self.model.slots / 2)) * GameScene.elevatorSpace
        
        x += GameScene.elevatorSize.width / 2
        x += GameScene.elevatorSize.width * CGFloat(slot)
        x += GameScene.elevatorSpace * CGFloat(slot)
        
        return x
    }
    
    func elevatorYPosition(at floor: Int) -> CGFloat {
        var y: CGFloat = floorYPosition(at: floor)
        
        y += GameScene.floorBaseSize.height
        
        return y
    }
    
    var currentFloorYPosition: CGFloat {
        return GameScene.bottomSpace
    }
    
    func floorYPosition(at floor: Int) -> CGFloat {
        var y: CGFloat = currentFloorYPosition
        
        y += CGFloat(floor - playerNode.floor) * GameScene.floorSize.height
        
        return y
    }
    
    func cableYPosition(at floor: Int) -> CGFloat {
        return floorYPosition(at: floor)
    }
}

// Rendering Floors
fileprivate extension GameScene {
    
    var validFloors: ClosedRange<Int> {
        return (1 ... model.floors)
    }
    
    var rendered: Range<Int> {
        return playerNode.floor - Int(GameScene.maxFloorsShown.rounded(.up)) ..< playerNode.floor + Int(GameScene.maxFloorsShown.rounded(.up))
    }
    
    func shouldRender(elevator: ElevatorModel) -> Bool {
        rendered.contains(elevator.floor) || rendered.contains(elevator.target)
    }
    
    func load(elevator: ElevatorModel) {
        
        guard elevator.floor != elevator.target else {
            print("Invalid Elevator Model \(elevator). Check Elevator's Floor & Target")
            return
        }
        
        do {
            let destination = ElevatorNode(floor: elevator.target, slot: elevator.slot)
            
            destination.position.y = elevatorYPosition(at: elevator.target)
            destination.position.x = elevatorXPosition(at: elevator.slot)
                        
            self.addChild(destination)
        }
        
        do {
            let origin = ElevatorNode(floor: elevator.floor, slot: elevator.slot)
            
            origin.position.y = elevatorYPosition(at: elevator.floor)
            origin.position.x = elevatorXPosition(at: elevator.slot)
            
            self.addChild(origin)
        }
        
        do {
            let cable = CableNode(length: elevator.distance, bottom: elevator.bottom)
            
            cable.position.y = elevatorYPosition(at: elevator.floor)
            cable.position.x = elevatorXPosition(at: elevator.slot)
            
            self.addChild(cable)
        }
    }
    
    func load(_ floor: Int) {
        let node = FloorNode(floor: floor)
        
        node.position.y = floorYPosition(at: floor)
        
        self.addChild(node)
    }
    
    func load(_ model: CoinModel) {
        let node = CoinNode(model: model)
        
        node.position.x = elevatorXPosition(at: model.slot)
        node.position.y = elevatorYPosition(at: model.floor)
        
        self.addChild(node)
    }
    
    var currentFloorOffset: CGFloat {
        let distance = CGFloat(rendered.lowerBound - playerNode.floor)
        return distance * GameScene.floorSize.height
    }
    
    func render() {
        // Load elevators
        for elevator in model.elevators where shouldRender(elevator: elevator) {
            // Ensure elevator has not yet been rendered
            if let originNode = originNode(for: elevator), let targetNode = targetNode(for: elevator) {
                originNode.position.y = elevatorYPosition(at: elevator.floor)
                targetNode.position.y = elevatorYPosition(at: elevator.target)
            } else {
                self.load(elevator: elevator)
            }
        }
        
        // Load floor nodes
        for floor in rendered where validFloors.contains(floor) {
            if let floorNode = floorNode(at: floor) {
                floorNode.position.y = floorYPosition(at: floor)
            } else {
                self.load(floor)
            }
        }
        // Coins
        for coin in model.coins where rendered.contains(coin.floor) {
            if let node = self.coin(for: coin) {
                node.position.x = elevatorXPosition(at: coin.slot)
                node.position.y = elevatorYPosition(at: coin.floor)
            } else {
                self.load(coin)
            }
        }
        
        // Cables
        for cableNode in cableNodes where rendered.contains(cableNode.bottom) {
            cableNode.position.y = cableYPosition(at: cableNode.bottom)
        }
        
        // Open all elevators on the player's floor.
        for elevatorNode in elevatorNodes(on: playerNode.floor) where !elevatorNode.isOpen {
            elevatorNode.open(wait: Double(elevatorNode.slot) * 0.05)
        }
    }
    // Remove any floor or elevator that is shouldn't be rendered
    func clean() {
        
        for elevatorNode in elevatorNodes where !rendered.contains(elevatorNode.floor) {
            elevatorNode.removeFromParent()
        }
        
        for floorNode in floorNodes where !rendered.contains(floorNode.floor) {
            floorNode.removeFromParent()
        }
        
        for cableNode in cableNodes where !rendered.contains(cableNode.bottom) {
            cableNode.removeFromParent()
        }
        
        for coinNode in coinNodes where !rendered.contains(coinNode.model.floor) {
            coinNode.removeFromParent()
        }
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
        playerNode.position.y = playerYPosition()
        
        self.addChild(playerNode)
    }
    
    func playerYPosition() -> CGFloat {
        var y: CGFloat = -3.25 // TODO: Images have a weird spacing, needs to be removed in final builds
        
        y += elevatorYPosition(at: playerNode.floor)
        
        return y
    }
}

extension GameScene {
    func right() {
        guard !playerNode.isInsideElevator, !playerNode.isMoving else {
            return
        }
        
        var range = Array(playerNode.slot ..< model.slots)
        
        if !range.isEmpty {
            range.removeFirst()
        }
        
        guard let slot = range.first(where: { (slot) -> Bool in
            elevator(at: slot, on: playerNode.floor) != nil
        }) else {
            return
        }
        
        self.playerNode.move(to: slot)
    }
    
    func left() {
        guard !playerNode.isInsideElevator, !playerNode.isMoving else {
            return
        }
        
        let range = Array(0 ..< playerNode.slot).reversed() as [Int]
        
        guard let slot = range.first(where: { (slot) -> Bool in
            elevator(at: slot, on: playerNode.floor) != nil
        }) else {
            return
        }
        
        self.playerNode.move(to: slot)
    }
}
extension GameScene {
    func ride() {
        // Player cannot be inside a elevator.
        // Player must be on a elevator
        guard !playerNode.isInsideElevator, let elevator = playerElevator() else {
            return
        }
        
        self.stopWave()
        
        var target: Int!, origin: Int!
        
        switch playerNode.floor {
        case elevator.bottom:
            target = elevator.top
            origin = elevator.bottom
            
            break
        case elevator.top:
            target = elevator.bottom
            origin = elevator.top
            break
        default:
            return
        }
        
        let distance = target - playerNode.floor
        
        let cameraSpeed: TimeInterval = Double(abs(distance)) * GameScene.cameraSpeed
                
        PlayerSkin.current.set(state: .idle)
                
        self.camera?.run(
            .sequence(
                [
                    SKAction.run(duration: GameScene.doorSpeed) {
                        self.playerNode.enter()
                    },
                    SKAction.run(duration: GameScene.doorSpeed) {
                        self.elevatorNodes(on: origin).forEach { (elevatorNode) in
                            elevatorNode.close()
                        }
                    },
                    SKAction.moveTo(
                        y: self.cameraOrigin.y + self.cameraYTranslation(distance: distance),
                        duration: cameraSpeed
                    ),
                    SKAction.run(duration: GameScene.doorSpeed) {
                        self.playerNode.floor = target
                        self.playerNode.position.y = self.playerYPosition()
                        self.render() // Opens the target Elevator
                        self.clean()
                        self.camera?.position = self.cameraOrigin
                    },
                    SKAction.run(duration: GameScene.doorSpeed) {
                        self.playerNode.exit()
                    },
                    SKAction.run {
                        self.startWave()
                    }
                ]
            )
        )
    }
}


extension GameScene {
    
    static let moveFeedback = UIImpactFeedbackGenerator(style: .light)
    static let rideFeedback = UIImpactFeedbackGenerator(style: .heavy)
    
    func attemptLongTouch(threshold: TimeInterval = 0.3) {
        DispatchQueue.main.asyncAfter(deadline: .now() + threshold) {
            if self.isTouching && !self.playerNode.isInsideElevator && !self.playerNode.isMoving {
                // Ignore next touch end.
                self.didSucceedLongTouch = true
                // Give user feedback
                GameScene.rideFeedback.impactOccurred()
                // Enter/Exit
                self.ride()
            }
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isTouching {
            self.isTouching.toggle()
            self.attemptLongTouch()
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isTouching = false
        
        if !self.didSucceedLongTouch, let touch = touches.first {
            // Apply feedback
            GameScene.moveFeedback.impactOccurred()
            // Move
            if touch.location(in: self).x < frame.midX {
                self.left()
            } else {
                self.right()
            }
        }
        
        self.didSucceedLongTouch = false
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

        self.addChild(camera)

        self.camera = camera
    }
}

extension GameScene {
    
    func startWave() {
        self.camera?.run(
            .sequence(
                [
                    SKAction.group(
                        [
//                            SKAction.scale(to: 0.75, duration: GameScene.waveSpeed),
                            SKAction.moveBy(
                                x: 0,
                                y: GameScene.bottomSpace,
                                duration: GameScene.waveSpeed
                            )
                        ]
                    ),
                    SKAction.run {
                        // You loose.
                        // close all elevators
                        self.elevatorNodes.forEach { (elevatorNode) in
                            elevatorNode.close()
                        }
                        self.hasEnded = true
                    }
                ]
            ),
            withKey: "wave"
        )
    }
    
    // When the player rides, it should cancel
    func stopWave() {
        camera?.removeAction(forKey: "wave")
//        camera?.run(SKAction.scale(to: 1.0, duration: GameScene.waveSpeed))
    }
}


import SwiftUI

struct GameScene_Previews: PreviewProvider {
    static var previews: some View {
        GameView_Previews.previews
    }
}