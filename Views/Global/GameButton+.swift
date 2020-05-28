//
//  GameButton+.swift
//  Elevators
//
//  Created by Peter Larson on 5/25/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

public struct ButtonScaleKey: EnvironmentKey {
    public static let defaultValue = true
}

public struct ButtonPressHandlerKey: EnvironmentKey {
    public static let defaultValue: (() -> Void)? = nil
}

public struct ButtonPaddingKey: EnvironmentKey {
    public static let defaultValue: CGFloat = 5
}

public struct ButtonCornerRadiusKey: EnvironmentKey {
    public static let defaultValue: CGFloat = 8
}

public extension EnvironmentValues {
    var buttonScales: Bool {
        get {
            return self[ButtonScaleKey.self]
        }
        
        set {
            self[ButtonScaleKey.self] = newValue
        }
    }
    
    var buttonHandler: (() -> Void)? {
        get {
            return self[ButtonPressHandlerKey.self]
        }
        
        set {
            self[ButtonPressHandlerKey.self] = newValue
        }
    }
    
    var buttonPadding: CGFloat {
        get {
            return self[ButtonPaddingKey.self]
        }
        
        set {
            self[ButtonPaddingKey.self] = newValue
        }
    }
    
    var buttonCornerRadius: CGFloat {
        get {
            return self[ButtonCornerRadiusKey.self]
        }
        
        set {
            self[ButtonCornerRadiusKey.self] = newValue
        }
    }
}

public extension View {
    @inlinable func doesButtonScale(enabled: Bool) -> some View {
        self.environment(\.buttonScales, enabled)
    }
    
    @inlinable func onButtonPress(_ handler: @escaping () -> Void) -> some View {
        self.environment(\.buttonHandler, handler)
    }
    
    @inlinable func buttonPadding(value: CGFloat) -> some View {
        self.environment(\.buttonPadding, value)
    }
    
    @inlinable func buttonCornerRadius(_ value: CGFloat) -> some View {
        self.environment(\.buttonCornerRadius, value)
    }
}
