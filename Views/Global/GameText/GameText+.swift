//
//  GameText+.swift
//  Elevators
//
//  Created by Peter Larson on 7/8/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

public struct GameTextSizeKey: EnvironmentKey {
    public static let defaultValue: CGFloat = 24
}

public extension EnvironmentValues {
    var gameTextSize: CGFloat {
        get {
            return self[GameTextSizeKey.self]
        }
        
        set {
            self[GameTextSizeKey.self] = newValue
        }
    }
}


public extension View {
    @inlinable func gameTextSize(_ value: CGFloat) -> some View {
        self.environment(\.gameTextSize, value)
    }
}
