//
//  LevelStorage.swift
//  Elevators
//
//  Created by Peter Larson on 5/10/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SpriteKit

let GameData = Storage()

public class Storage: ObservableObject {
    let storage = UserDefaults()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    // All levels, local and hard file.
    @Published public var levels: [LevelModel]
    @Published public var buck: Int
    @Published public var streak: Int
    @Published public var recentClaim: Date?
    @Published public var credits: [String]
    @Published public var outfit: PlayerOutfit
    // Player Outfit Dependents
    // var outfitCache = [String:SKTexture]()
    // Save of local models
    private var local: [LevelModel]
    
    func move(offsets: IndexSet, destination: Int) {
        levels.move(fromOffsets: offsets, toOffset: destination)
        
        levels.enumerated().forEach { index, model in
            levels[index].id = index
        }
    }
    
    func isLocalallySaved(model: LevelModel) -> Bool {
        local.contains(model)
    }
    
    public func remove(_ indexSet: IndexSet) {
        
        for index in indexSet {
            let target = levels[index]
            
            if isLocalallySaved(model: target) {
                local.removeAll { (model) -> Bool in
                    model == target
                }
            } else {
                print("Cannot removed hard saved level!")
            }
            
            levels.removeAll { (model) -> Bool in
                model == target
            }
        }
        // Update id's
        
    }
    
    public func save(_ model: LevelModel) {
        var replaced = false
        
        print("Saving \(model) to Local File. Current Levels: \(levels.map { $0.id }).")
        
        // Replace in locals
        for (index, level) in levels.enumerated() {
            if level == model {
                print("\t", "replacing \(levels[index]) with \(model)")
                levels[index] = model
                replaced = true
                break
            }
        }
        if replaced {
            for (index, level) in local.enumerated() {
                if level == model {
                    levels[index] = model
                    break
                }
            }
        }
        
        if !replaced {
            levels.append(model)
            local.append(model)
        }
        
        
        self.save()
        
        print("\t\t", self.levels)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("\t\t", self.levels)
        }
        
        print("Locally Saved. Replaced: \(replaced). Current Levels: \(levels.map { $0.id }).")
    }
    
    public func contains(_ name: String) -> Bool {
        levels.contains { (model) -> Bool in
            model.name == name
        }
    }
    
    fileprivate init() {
        self.streak = storage.integer(forKey: "streak")
        self.recentClaim = storage.object(forKey: "recentClaim") as? Date
        self.buck = storage.integer(forKey: "buck")
        self.credits = storage.stringArray(forKey: "credits") ?? []
        self.outfit = PlayerOutfit(rawValue: storage.string(forKey: "outfit") ?? String()) ?? PlayerOutfit.goose
        
        if let localData = storage.data(forKey: "levels"),
            let localSave = try? decoder.decode([LevelModel].self, from: localData) {
            levels = localSave
            local = localSave
        } else {
            levels = [LevelModel]()
            local = [LevelModel]()
        }
        
        if
            let hardFolder = Bundle.main.urls(forResourcesWithExtension: "txt", subdirectory: nil)
        {
            
            print("Attempting to Load \(hardFolder.count) Levels from File.")
            
            for url in hardFolder {
                print("\(url.lastPathComponent)...")
                guard
                    let data = try? Data(contentsOf: url),
                    let model = decode(data)
                    else {
                        continue
                }
                
                print("Read Level from File (\(url.lastPathComponent))")
                
                levels.append(model)
            }
        }
        
        print("Loaded \(levels.count) Levels (\(local.count) Local).")
        
        levels.sort { (m1, m2) -> Bool in
            m1.id < m2.id
        }
        
        levels.forEach { (model) in
            print("\t", model.id, model.name)
        }
        
        print("Player Outfit = ", outfit.rawValue)
    }
    
    func save() {
        storage.set(streak, forKey: "streak")
        storage.set(recentClaim, forKey: "recentClaim")
        storage.set(buck, forKey: "buck")
        storage.set(credits, forKey: "credits")
        storage.set(outfit.rawValue, forKey: "outfit")
        
        do {
            let data = try encoder.encode(local)
            
            storage.set(data, forKey: "levels")
            
            guard
                let localData = storage.data(forKey: "levels"),
                let localSave = try? decoder.decode([LevelModel].self, from: localData)
                else {
                    
                    print("FAILED TO LOAD FROM SAVE.")
                    
                    return
            }
            
            localSave.forEach { (model) in
                print("Saved \(model).")
            }
        } catch {
            print("FAILED TO SAVE LOCAL MODELS.", error)
        }
    }
    
    func data(from model: LevelModel) -> Data? {
        try? encoder.encode(model)
    }
    
    func decode(_ data: Data) -> LevelModel? {
        try? decoder.decode(LevelModel.self, from: data)
    }
    
    func getFile(for id: Int) -> NSURL? {
        guard
            let model = levels.first(where: { (model) -> Bool in
                model.id == id
            }),
            let data = try? encoder.encode(model),
            let file = data.dataToFile(fileName: "level_\(model.name)-\(model.id).txt")
            else {
                return nil
        }
        
        return file
    }
    
    func level(named name: String) -> LevelModel? {
        levels.first { (model) -> Bool in
            model.name == name
        }
    }
    
    var settings: GameSettingsModel {
        get {
            if let data = storage.data(forKey: "settings"), let value = try? decoder.decode(GameSettingsModel.self, from: data) {
                // Update GameScene
                GameScene.maxFloorsShown = value.maxFloorsShown
                GameScene.floorSpeed = value.floorSpeed
                GameScene.playerSpeed = value.playerSpeed
                GameScene.doorSpeed = value.doorSpeed
                GameScene.waveSpeed = value.waveSpeed
                GameScene.cameraSpeed = value.cameraSpeed
                GameScene.padding = value.padding
                
                return value
            } else {
                return GameSettingsModel()
            }
        }
        
        set {
            storage.set(try? encoder.encode(newValue), forKey: "settings")
            
            GameScene.maxFloorsShown = newValue.maxFloorsShown
            GameScene.floorSpeed = newValue.floorSpeed
            GameScene.playerSpeed = newValue.playerSpeed
            GameScene.doorSpeed = newValue.doorSpeed
            GameScene.waveSpeed = newValue.waveSpeed
            GameScene.cameraSpeed = newValue.cameraSpeed
            GameScene.padding = newValue.padding
        }
    }
    
    func checkCreditsRewards() {
        credits.removeAll { (username) -> Bool in
            guard let date = storage.object(forKey: "credit." + username) as? Date else {
                return false
            }
            
            return (Calendar.current.dateComponents([.day], from: date).day ?? 0) >= 7
        }
    }
    
    func collect(_ username: String) {
        self.credits.append(username)
        
        storage.set(Date(), forKey: "credit." + username)
    }
}

// Level Saving
extension Storage {
    public func isComplete(model: LevelModel) -> Bool {
        (storage.array(forKey: "completed") as? [Int])?.contains(model.id) ?? false
    }
    
    public func markCompleted(model: LevelModel) {
        var completed = (storage.array(forKey: "completed") as? [Int]) ?? [Int]()
        
        completed.append(model.id)
        
        storage.set(completed, forKey: "completed")
    }
}

// Level Loading
extension Storage {
    var levelsList: [LevelModel] {
        levels.sorted { (l1, l2) -> Bool in
            l1.id < l2.id
        }
    }
    
    func next(from level: LevelModel) -> LevelModel? {
        levelsList.filter { (l) -> Bool in
            l <= level
        }.first
    }
    
    var currentLevel: LevelModel? {
        levelsList.first { (model) -> Bool in
            !isComplete(model: model)
        }
    }
}

// Player Outfit Cache
//extension Storage {
//    
//    private func fileName(for state: PlayerState, direction: PlayerDirection? = nil, frame: Int) -> String {
//        if !outfit.isSymmetric, let direction = direction {
//            return "\(outfit.rawValue)-\(state)-\(direction)-\(frame)"
//        } else {
//            return "\(outfit.rawValue)-\(state)-\(frame)"
//        }
//    }
//    
//    func resetOutiftCache() {
//        outfitCache = [:]
//        
//        // 14 Frames for each direction and state.
//        var name: String!
//        
//        (1 ... 14).forEach { frame in
//            PlayerState.allCases.forEach { (state) in
//                if outfit.isSymmetric {
//                    name = fileName(for: state, frame: frame)
//                    outfitCache[name] = SKTexture(imageNamed: name)
//                } else {
//                    PlayerDirection.allCases.forEach { (direction) in
//                        name = fileName(for: state, direction: direction, frame: frame)
//                        outfitCache[name] = SKTexture(imageNamed: name)
//                    }
//                }
//            }
//        }
//        
//        SKTexture.preload(Array(outfitCache.values)) {
//            print("Loaded Player Outfit Textures for", self.outfit.rawValue)
//        }
//    }
//    
//    func frames(for node: PlayerNode) -> [SKTexture] {
//        return (1 ... 14).compactMap { (frame) -> SKTexture? in
//            let texture = outfitCache[fileName(for: node.state, direction: node.direction, frame: frame)]
//            
//            if texture == nil {
//                print("WARNING - Player Frame for", outfit.rawValue, node.state, node.direction, "is not loaded in the cache!")
//            }
//            
//            return texture
//        }
//    }
//}
