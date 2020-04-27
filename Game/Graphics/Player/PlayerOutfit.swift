//
//  PlayerOutfit.swift
//  Elevators
//
//  Created by Peter Larson on 4/12/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation

public enum PlayerOutfit: String, CaseIterable, Hashable {
    case chef
    
    public var description: String {
        switch self {
        case .chef:
            return "Glad he's carrying a pan not a knife!"
        }
    }
    
    public var cost: Int {
        switch self {
        case .chef:
            return 100
        }
    }
    
    var isUnlocked: Bool {
        switch self {
        case .chef:
            return true
        default:
            return UserDefaults.standard.bool(forKey: "outfit.")
        }
    }
}
