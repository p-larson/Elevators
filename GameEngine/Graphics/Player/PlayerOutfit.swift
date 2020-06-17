//
//  PlayerOutfit.swift
//  Elevators
//
//  Created by Peter Larson on 4/12/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation

public enum PlayerOutfit: String, CaseIterable, Hashable {
    case firefighter, orange, strawberry, goose
    
    public var description: String {
        switch self {
//        case .chef:
//            return "Glad he's carrying a pan not a knife!"
        case .firefighter:
            return "He fights fire."
        case .orange:
            return "Big pulpe guy"
        case .strawberry:
            return "\"GMO Certified\" - Evan - \"No that's Dumb\" - Evan"
        case .goose:
            return "If you're going to act like a silly goose, go to the pond."
        }
    }
    
    public var isSymmetric: Bool {
        switch self {
        case .firefighter:
            return false
        default:
            return true
        }
    }
    
    var isUnlocked: Bool {
        switch self {
        default:
            return UserDefaults.standard.bool(forKey: "outfit.")
        }
    }
}
