//
//  LevelStorage.swift
//  Elevators
//
//  Created by Peter Larson on 5/10/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation

public class LevelStorage: ObservableObject {
    public static let current = LevelStorage()
    
    private let storage = UserDefaults()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // All levels, local and hard file.
    @Published public var levels: [LevelModel]
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
    
    private init() {
        if
            let localData = storage.data(forKey: "levels"),
            let localSave = try? decoder.decode([LevelModel].self, from: localData),
            let hardFolder = Bundle.main.urls(forResourcesWithExtension: "txt", subdirectory: nil)
        {
            levels = localSave
            local = localSave
            
            for url in hardFolder {
                guard
                    let data = try? Data(contentsOf: url),
                    let model = decode(data)
                else {
                    continue
                }
                
                levels.append(model)
            }
        } else {
            levels = [LevelModel]()
            local = [LevelModel]()
            
            // levels = [.demo]
            // local = [.demo]
        }
        
        print("Loaded \(levels.count) Levels (\(local.count) Local).")
        
        levels.sorted { (m1, m2) -> Bool in
            m1.id < m2.id
        }.forEach { (model) in
            print("\t", model.id, model.name)
        }
    }
    
    func save() {
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
}
