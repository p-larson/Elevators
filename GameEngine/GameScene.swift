//
//  GameScene.swift
//  Elevators
//
//  Created by Peter Larson on 4/19/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SpriteKit
import Haptica

final public class GameScene: SKScene, ObservableObject {
    // Model
    var model: LevelModel {
        didSet {
            // Disable game.
            self.isPlaying = false
        }
    }
    // Touching
    fileprivate var lastTouchX: CGFloat? = nil
    // Player Node
    var playerNode: PlayerNode!
    // Published State
    @Published private(set) public var isLoaded = false
    @Published var isPlaying: Bool = false {
        didSet {
            if isPlaying && isLoaded {
                self.startClosingWave()
            }
        }
    }
    @Published var hasWon: Bool = false
    @Published var hasLost: Bool = false
    @Published var isSendingElevator = false
    
    // INIT
    init(model: LevelModel) {
        self.model = model
        
        super.init(size: UIScreen.main.bounds.size)
        
        self.backgroundColor = .clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

// Game Settings
public extension GameScene {
    static var maxFloorsShown: CGFloat = 6
    static var floorSpeed: TimeInterval = 0.2
    static var playerSpeed: TimeInterval = 0.3
    static var doorSpeed: TimeInterval = 0.15
    static var waveSpeed: TimeInterval = 3.0
    static var cameraSpeed: TimeInterval = 0.15
    static var padding: CGFloat = 16.0
    static let slots: Int = 5
    static var maxSlot: Int { slots - 1 }
    static let touchThreshold: CGFloat = 10.0
}

// Setup
extension GameScene {
    public func reload() {
        self.removeAllChildren()
        self.isLoaded = false
        self.setupPlayer()
        self.render()
        self.clean()
        self.setupCamera()
        self.updateTarget()
        self.hasLost = false
        self.hasWon = false
        self.isPlaying = false
        self.isLoaded = true
        print("Loading Scene. \(model.slots) Slots, \(model.floors) Floors, \(model.elevators.count) Elevators, \(model.coins.count) Coins.")
    }
    
    public override func didMove(to view: SKView) {
        self.reload()
    }
}

// Accessing Child Nodes
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
    
    func elevatorNode(on floor: Int, at slot: Int) -> ElevatorNode? {
        elevatorNodes(on: floor).first { (node) -> Bool in
            node.slot == slot
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
    
    func baseElevators(on floor: Int) -> [ElevatorModel] {
        model.elevators.filter { (elevator) -> Bool in
            elevator.bottom == floor
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
    
    func closestElevatorNode() -> ElevatorNode? {
        elevatorNodes(on: playerNode.floor).min { (node1, node2) -> Bool in
            abs(node1.position.x - playerNode.position.x) < abs(node2.position.x - playerNode.position.x)
        }
    }
    
    func playerElevatorNode() -> ElevatorNode? {
        elevatorNode(on: playerNode.floor, at: playerNode.slot)
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
    
    func cableNode(for model: ElevatorModel) -> CableNode? {
        cableNodes.first { (node) -> Bool in
            node.floor == model.floor && node.slot == model.slot
        }
    }
    
    var coinNodes: [CoinNode] {
        children.compactMap { (child) -> CoinNode? in
            child as? CoinNode
        }
    }
    
    func playerCoin() -> CoinNode? {
        coinNodes.first { (node) -> Bool in
            node.model.floor == playerNode.floor && node.model.slot == playerNode.slot
        }
    }
    
    
}
// Slot
//extension GameScene {
//    static var maxSlot: Int {
//        slots - 1
//    }
//    
//    var validSlots: Range<Int> {
//        0 ..< model.slots
//    }
//}

// Game Aspect Ratios / Sizing
extension GameScene {
    static var floorSize: CGSize {
        return CGSize(
            width: UIScreen.main.bounds.size.width - GameScene.padding * 2,
            height: UIScreen.main.bounds.size.height / GameScene.maxFloorsShown
        )
    }
    
    static var floorBaseSize: CGSize {
        return CGSize(
            width: GameScene.floorSize.width,
            height: UIScreen.main.bounds.size.height / GameScene.maxFloorsShown / 12
        )
    }
    
    static var floorWallPaperSize: CGSize {
        return CGSize(
            width: UIScreen.main.bounds.size.width,
            height: (GameScene.floorSize.height - GameScene.floorBaseSize.height)
        )
    }
    
    static var elevatorSize: CGSize {
        let width = (GameScene.floorSize.width / CGFloat(slots) - padding)
        
        return CGSize(
            width: width,
            height: width * (7/5)
        )
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
    
    static var bottomSpace: CGFloat {
        return UIScreen.main.bounds.size.height / 5
    }
    
    static func cableSize(of length: Int) -> CGSize {
        return CGSize(
            width: elevatorSize.width / 8,
            height: floorSize.height * CGFloat(length) - elevatorSize.height - GameScene.floorBaseSize.height
        )
    }
    
    static var finishLineSize: CGSize {
        return CGSize(
            width: UIScreen.main.bounds.width,
            height: GameScene.floorSize.height / 5
        )
    }
}
// Positioning
public extension GameScene {
    
    var slotWidth: CGFloat {
        ((GameScene.floorSize.width - GameScene.padding * 2) / CGFloat(self.model.slots))
    }
    
    func elevatorXPosition(at slot: Int) -> CGFloat {
        var x: CGFloat = 0
        
        x += UIScreen.main.bounds.midX
        x -= (GameScene.floorSize.width) / 2
        x += GameScene.padding
        x += slotWidth / 2
        x += slotWidth * CGFloat(slot)
        
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
        return floorYPosition(at: floor) + GameScene.elevatorSize.height + GameScene.floorBaseSize.height
    }
}
// Rendering
fileprivate extension GameScene {
    
    var currentFarthestElevatorRange: Int {
        return elevators(on: playerNode.floor).max { (e1, e2) -> Bool in
            e1.distance < e2.distance
            }?.distance ?? 0
    }
    
    var validFloors: ClosedRange<Int> {
        return (1 ... model.floors)
    }
    
    var rendered: Range<Int> {
        playerNode.floor - Int(GameScene.maxFloorsShown.rounded(.up)) ..< playerNode.floor + Int(GameScene.maxFloorsShown.rounded(.up)) + currentFarthestElevatorRange
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
            let destination = ElevatorNode(floor: elevator.target, slot: elevator.slot, target: elevator.floor)
            
            destination.position.y = elevatorYPosition(at: elevator.target)
            destination.position.x = elevatorXPosition(at: elevator.slot)
            
            self.addChild(destination)
        }
        
        do {
            let origin = ElevatorNode(floor: elevator.floor, slot: elevator.slot, target: elevator.target)
            
            origin.position.y = elevatorYPosition(at: elevator.floor)
            origin.position.x = elevatorXPosition(at: elevator.slot)
            
            self.addChild(origin)
        }
        
        do {
            let cable = CableNode(length: elevator.distance, floor: elevator.floor, slot: elevator.slot)
            
            cable.position.y = elevatorYPosition(at: elevator.floor)
            cable.position.x = elevatorXPosition(at: elevator.slot)
            
            self.addChild(cable)
        }
    }
    
    func load(_ floor: Int) {
        let node = FloorNode(floor: floor, isFinal: floor == model.floors)
        
        node.position.y = floorYPosition(at: floor)
        
        self.addChild(node)
    }
    
    func load(_ model: CoinModel) {
        let node = CoinNode(model: model)
        
        node.position.x = elevatorXPosition(at: model.slot)
        node.position.y = elevatorYPosition(at: model.floor) + GameScene.coinSize.height
        
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
                node.position.y = elevatorYPosition(at: coin.floor) + GameScene.coinSize.height
            } else {
                self.load(coin)
            }
        }
        
        // Cables
        for cableNode in cableNodes where rendered.contains(cableNode.floor) {
            cableNode.position.y = cableYPosition(at: cableNode.floor)
        }
        
        for elevator in model.elevators where elevator.bottom == playerNode.floor {
            if let node = originNode(for: elevator), !node.isOpen && node.isEnabled {
                node.open(animates: playerNode.floor != 1)
            }
        }
        
        // Clean
        self.clean()
    }
    // Remove any floor or elevator that is shouldn't be rendered
    func clean() {
        
        for elevatorNode in elevatorNodes where !rendered.contains(elevatorNode.floor) && !rendered.contains(elevatorNode.target) {
            elevatorNode.removeFromParent()
        }
        
        for floorNode in floorNodes where !rendered.contains(floorNode.floor) {
            floorNode.removeFromParent()
        }
        
        for cableNode in cableNodes where !rendered.contains(cableNode.floor) {
            cableNode.removeFromParent()
        }
        
        for coinNode in coinNodes where !rendered.contains(coinNode.model.floor) {
            coinNode.removeFromParent()
        }
    }
}
// Player Setup
extension GameScene {
    func setupPlayer() {
        // Setup x Position
        self.playerNode = PlayerNode(floor: 1)
        
        if let first = self.elevators(on: 1).first {
            playerNode.slot = first.slot
        }
        
        playerNode.position.x = self.elevatorXPosition(at: playerNode.slot)
        playerNode.position.y = playerYPosition()
        
        self.addChild(playerNode)
        
        PlayerSkin.current.animate(playerNode)
    }
    
    func playerYPosition() -> CGFloat {
        var y: CGFloat = 0 // TODO: Images have a weird spacing, needs to be removed in final builds
        
        y += elevatorYPosition(at: playerNode.floor)
        
        return y
    }
}
// Riding
extension GameScene {
    func attemptRide() {
        guard
            !playerNode.isInsideElevator,
            !hasWon,
            !hasLost,
            !playerNode.isCentering,
            !playerNode.isInsideElevator,
            !playerNode.isMoving
            else {
                return
        }
        
        self.run(SKAction.wait(forDuration: playerNode.center()), completion: ride)
        
        //
    }
    
    @objc func ride() {
        // Player cannot be inside a elevator.
        // Player must be on a elevator
        guard
            !playerNode.isInsideElevator,
            let elevator = playerElevator(),
            let elevatorNode = playerElevatorNode(),
            !hasWon,
            !hasLost
            else {
                return
        }
        
        guard !playerNode.isMoving else {
            playerNode.willEnter = true
            return
        }
        
        if !elevatorNode.isEnabled || elevator.top == playerNode.floor {
            
            Haptic.notification(.warning).generate()
            
            elevatorNode.shimmy()
            
            return
        }
        
        var target: Int!, origin: Int!
        
        switch playerNode.floor {
        case elevator.bottom:
            target = elevator.top
            origin = elevator.bottom
            isSendingElevator = true
            break
        case elevator.top:
            target = elevator.bottom
            origin = elevator.top
            isSendingElevator = false
            break
        default:
            return
        }
        
        targetNode(for: elevator)?.isEnabled = false
        originNode(for: elevator)?.isEnabled = false
        
        let distance = target - playerNode.floor
        
        let cameraSpeed: TimeInterval = Double(abs(distance)) * GameScene.cameraSpeed
        
        PlayerSkin.current.set(state: .idle)
        
        Haptic.impact(.light).generate()
        
        self.cancelClosingWave()
        
        // open the elevator
        
        self.camera?.run(
            .sequence(
                [
                    SKAction.wait(forDuration: playerNode.center()),
                    SKAction.run(duration: GameScene.doorSpeed) {
                        elevatorNode.open(animates: true)
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
                        self.targetNode(for: elevator)?.open(animates: true)
                    },
                    SKAction.run(duration: GameScene.doorSpeed) {
                        self.targetNode(for: elevator)?.close()
                        self.playerNode.exit()
                    },
                    SKAction.run {
                        if self.playerNode.floor == self.model.floors {
                            self.hasWon = true
                            
                            self.elevatorNodes.forEach { (node) in
                                let d = self.model.floors - node.floor
                                
                                if d != 0 {
                                    node.run(.fadeOut(withDuration: Double((GameScene.maxFloorsShown - CGFloat(d))) * 0.3))
                                }
                            }
                            
                            self.floorNodes.forEach { (node) in
                                let d = self.model.floors - node.floor
                                
                                if d != 0 {
                                    node.run(.fadeOut(withDuration: Double((GameScene.maxFloorsShown - CGFloat(d))) * 0.3))
                                }
                            }
                            
                            self.cableNodes.forEach { (node) in
                                let d = self.model.floors - node.floor
                                
                                if d != 0 {
                                    node.run(.fadeOut(withDuration: Double((GameScene.maxFloorsShown - CGFloat(d))) * 0.3))
                                }
                            }
                            
                            Haptic.notification(.success).generate()
                            // self.moveCameraToPlayer()
                        } else {
                            self.isPlaying = true
                        }
                    }
                ]
            )
        )
    }
}

// Move Testing
extension GameScene {
    var hasAvailableMove: Bool {
        elevatorNodes(on: playerNode.floor).contains { (node) -> Bool in
            node.isEnabled && node.isOpen
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
        
        self.addChild(camera)
        
        self.camera = camera
    }
}

// Wave 2.0
extension GameScene {
    // Instead of the screen moving, have the elevators close slowly.
    // When all of the elevators are closed, and the pridelayer hasn't picked
    // one yet, they lose.
    func startClosingWave() {
        
        if !hasAvailableMove {
            print("has no available move!")
            kill()
            return
        }
        
        elevatorNodes(on: playerNode.floor).forEach { (node) in
            node.waveClose()
        }
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: GameScene.waveSpeed), SKAction.run(kill)]), withKey: "wave")
    }
    
    func kill() {
        self.hasLost = true
        self.isPlaying = false
        
        print("lost!")
    }
    
    func cancelClosingWave() {
        self.removeAction(forKey: "wave")
    }
}

extension GameScene {
    
    func updateTarget() {
        self.checkCoins()
        
        guard
            let model = playerElevator(),
            let target = targetNode(for: model)?.overlay,
            let origin = originNode(for: model)?.overlay,
            let cable = cableNode(for: model)
            else {
                return
        }
        
        [target, origin, cable].forEach { (node) in
            node.run(
                SKAction
                    .sequence(
                        [
                            SKAction.scale(to: 1.1, duration: 0.15),
                            SKAction.scale(to: 1.0, duration: 0.15),
                        ]
                ).with(timing: .easeInEaseOut),
                withKey: "target"
            )
        }
        
        Haptic.impact(.light).generate()
    }
}

// Controls
extension GameScene {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isPlaying {
            self.isPlaying = true
        }
        
        guard let touch = touches.first else {
            return
        }
        
        self.lastTouchX = touch.location(in: self).x
        
        playerNode.set(direction: lastTouchX! < frame.midX ? .left : .right)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let x = touch.location(in: self).x
        
        if let lastTouchX = lastTouchX, abs(lastTouchX - x) > GameScene.touchThreshold {
            self.playerNode.set(direction: x < lastTouchX ? .left : .right)
            self.lastTouchX = x
        }
        
        // self.playerNode.set(direction: lastTouchX! < frame.midX ? .left : .right)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.playerNode.stopMoving()
        self.attemptRide()
        self.lastTouchX = nil
    }
}


// Coin Check
extension GameScene {
    func checkCoins() {
        guard let coin = playerCoin(), !coin.isCollected else {
            return
        }
        
        coin.collect()
    }
}

// Selected Slot Indication
extension GameScene {
    
    func clearIndicators() {
        [indicatorLabel, indicatorEmoji].forEach { node in
            node?.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3)]), completion: {
                node?.removeFromParent()
            })
        }
    }
    
    var indicatorLabel: SKNode? {
        get {
            childNode(withName: "indicatorLabel")
        }
        
        set {
            newValue?.name = "indicatorLabel"
            
            if let node = newValue, node.parent == nil {
                self.addChild(node)
            }
        }
    }
    
    var indicatorEmoji: SKNode? {
        get {
            childNode(withName: "indicatorEmoji")
            
        }
        
        set {
            newValue?.name = "indicatorEmoji"
            
            if let node = newValue, node.parent == nil {
                self.addChild(node)
            }
        }
    }
    
    func setupPressIndicator() {
        indicatorLabel = SKLabelNode(fontNamed: "Futura Medium")
        indicatorEmoji = SKLabelNode(text: "👆")
        
        do {
            let label = indicatorLabel as! SKLabelNode
            
            label.fontSize = 48
            label.text = "Level \(model.id)"
            label.position.y = floorYPosition(at: 0) - 24 + GameScene.floorSize.height / 2
            label.position.x = frame.midX
            label.zPosition = 1
        }
        
        do {
            let emoji = indicatorEmoji as! SKLabelNode
            
            emoji.position.y = indicatorLabel!.position.y - 80
            emoji.zPosition = 2
            emoji.fontSize = 64
            emoji.position.x = frame.midX
            
            emoji.run(
                SKAction.repeatForever(
                    .sequence(
                        [
                            SKAction.moveBy(x: 0, y: 16, duration: 0.5),
                            SKAction.moveBy(x: 0, y: -16, duration: 0.5)
                        ]
                    )
                ).with(timing: .easeInEaseOut)
            )
        }
    }
}

import SwiftUI

struct GameScene_Previews: PreviewProvider {
    static var previews: some View {
        GameView_Previews.previews
    }
}
