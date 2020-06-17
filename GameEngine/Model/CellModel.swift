//
//  CellModel.swift
//  Elevators
//
//  Created by Peter Larson on 5/7/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation

public struct CellModel: Identifiable, Encodable & Decodable {
    let slot: Int, floor: Int
    public let id = UUID()
    
    init(slot: Int, floor: Int) {
        self.slot = slot
        self.floor = floor
    }
    
    enum CodingKeys: CodingKey {
        case slot, floor
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(slot, forKey: .slot)
        try container.encode(floor, forKey: .floor)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.slot = try values.decode(Int.self, forKey: .slot)
        self.floor = try values.decode(Int.self, forKey: .floor)
    }
}

extension CellModel: CustomStringConvertible {
    public var description: String {
        return "(\(slot), \(floor))"
    }
}
