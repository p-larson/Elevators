//
//  LevelModel.swift
//  Elevators
//
//  Created by Peter Larson on 5/10/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation

public struct LevelModel: Identifiable, Codable, Hashable {
    
    fileprivate static let DEMO = Int.min
    
    public var name: String
    public var floors: Int
    public var slots: Int
    public var elevators: [ElevatorModel]
    public var bucks: [BuckModel]
    public var start: CellModel?
    public var id: Int
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    enum CodingKeys: CodingKey {
        case name, floors, slots, elevators, bucks, selected, start, id
    }
    
    init(name: String, floors: Int, slots: Int, elevators: [ElevatorModel], bucks: [BuckModel], start: CellModel? = nil, id: Int) {
        self.name = name
        self.floors = floors
        self.slots = slots
        self.elevators = elevators
        self.bucks = bucks
        self.start = start
        self.id = id
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(floors, forKey: .floors)
        try container.encode(slots, forKey: .slots)
        if !elevators.isEmpty {
            try container.encode(elevators, forKey: .elevators)
        }
        if !bucks.isEmpty {
            try container.encode(bucks, forKey: .bucks)
        }
        if start != nil {
            try container.encode(start, forKey: .start)
        }
        try container.encode(id, forKey: .id)
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try values.decode(String.self, forKey: .name)
        self.floors = try values.decode(Int.self, forKey: .floors)
        self.slots = try values.decode(Int.self, forKey: .slots)
        self.elevators = (try? values.decode([ElevatorModel].self, forKey: .elevators)) ?? [ElevatorModel]()
        self.bucks = (try? values.decode([BuckModel].self, forKey: .bucks)) ?? [BuckModel]()
        self.start = try? values.decode(CellModel.self, forKey: .start)
        self.id = try values.decode(Int.self, forKey: .id)
    }
}

extension LevelModel: CustomStringConvertible {
    public var description: String {
        "(\(id) \(name))"
    }
}

extension LevelModel: Equatable {
    public static func ==(lhs: LevelModel, rhs: LevelModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension LevelModel: Comparable {
    public static func < (lhs: LevelModel, rhs: LevelModel) -> Bool {
        lhs.id < rhs.id
    }
}

extension LevelModel {
    static var demo: LevelModel {
        LevelModel(
            name: "demo",
            floors: 5,
            slots: 5,
            elevators: [
                .init(floor: 1, slot: 0, target: 5),
            ],
            bucks: [
                .init(slot: 0, floor: 5)
            ],
            start: nil,
            id: 0
        )
    }
}
