//
//  CoinModel.swift
//  Elevators
//
//  Created by Peter Larson on 5/7/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation

public struct CoinModel: Identifiable, Encodable, Decodable, Equatable {
    public let id = UUID()
    let slot, floor: Int
    
    init(slot: Int, floor: Int) {
        self.slot = slot
        self.floor = floor
    }
    
    enum CodingKeys: CodingKey {
        case slot, floor
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.floor = try values.decode(Int.self, forKey: .floor)
            self.slot = try values.decode(Int.self, forKey: .slot)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(floor, forKey: .floor)
        try container.encode(slot, forKey: .slot)
    }
    
    public static func == (lhs: CoinModel, rhs: CoinModel) -> Bool {
        return lhs.floor == rhs.floor && lhs.slot == rhs.slot
    }
}

extension CoinModel: CustomStringConvertible {
    public var description: String {
        return "(\(slot), \(floor))"
    }
}
