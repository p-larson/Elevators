//
//  PlayerState.swift
//  Elevators
//
//  Created by Peter Larson on 4/12/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation

public enum PlayerState: Int, CaseIterable, Hashable {
    case idle, run
    
    public var hashValue: Int {
        return rawValue.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
