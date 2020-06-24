//
//  PlayerOutfit.swift
//  Elevators
//
//  Created by Peter Larson on 4/12/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation

public enum PlayerOutfit: String, CaseIterable, Hashable {
    case firefighter
    case orange
    case strawberry
    case goose
    case spaceman
    case spaceman2
    case spacewoman
    case camperlady
    case pinneapple
    case scuba
    case banana
    case chef
    case mailman
    
    public var description: [String] {
        switch self {
        case .firefighter:
            return ["fire!", "where?"]
        case .orange:
            return ["🍊"]
        case .strawberry:
            return ["berry", "barry"]
        case .goose:
            return ["quack"]
        case .spaceman, .spaceman2, .spacewoman:
            return ["🚀", "🛰", "👽?", ""]
        case .camperlady:
            return ["🔥"]
        case .pinneapple:
            return ["yes sir", "tropical vibes"]
        case .scuba:
            return ["blub blub", "blub", "🤿"]
        case .banana:
            return ["ba", "na", "na"]
        case .chef:
            return ["chop", "slice"]
        case .mailman:
            return ["you've got mail.", "dog?? where??"]
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
        case .orange, .goose:
            return true
        default:
            return UserDefaults.standard.bool(forKey: "outfit.")
        }
    }
    
    var name: String {
        switch self {
        case .spaceman2:
            return "Spaceman"
        default:
            return rawValue.prefix(1).uppercased() + rawValue.dropFirst().lowercased()
        }
    }
}
