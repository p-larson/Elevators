//
//  ElevatorModel.swift
//  Elevators
//
//  Created by Peter Larson on 3/3/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation

final class ElevatorModel: Identifiable, Decodable, Encodable {
    let target: Int
    let floor: Int
    let slot: Int
    
    weak var origin: ElevatorNode? = nil
    weak var destination: ElevatorNode? = nil
    
    init(floor: Int, slot: Int, target: Int) {
        self.floor = floor
        self.slot = slot
        self.target = target
    }
    
    enum CodingKeys: CodingKey {
        case floor, slot, target
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.floor = try values.decode(Int.self, forKey: .floor)
            self.slot = try values.decode(Int.self, forKey: .slot)
            self.target = try values.decode(Int.self, forKey: .target)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(floor, forKey: .floor)
        try container.encode(slot, forKey: .slot)
        try container.encode(target, forKey: .target)
    }
}

extension ElevatorModel {
    var distance: Int { target - floor }
}

extension ElevatorModel {
    var bottom: Int {
        return min(floor, target)
    }
    
    var bottomNode: ElevatorNode? {
        guard let origin = origin, let destination = destination else {
            return nil
        }
        
        if floor > target {
            return destination
        } else {
            return origin
        }
    }
    
    var top: Int {
        return max(floor, target)
    }
    
    var topNode: ElevatorNode? {
        guard let origin = origin, let destination = destination else {
            return nil
        }
        
        if floor < target {
            return destination
        } else {
            return origin
        }
    }
}

extension ElevatorModel {
    static let demo = ElevatorModel(floor: 1, slot: 1, target: 2)
    
    static let demo2 = ElevatorModel(floor: 3, slot: 2, target: 1)
}

extension ElevatorModel: CustomStringConvertible {
    var description: String {
        return [self.slot, "@", self.floor, "->",self.target].description
    }
}
