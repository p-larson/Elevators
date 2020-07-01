//
//  ScaleModifier.swift
//  Elevators
//
//  Created by Peter Larson on 6/30/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct ScaleModifier: ViewModifier {
    let x, y: CGFloat
    let anchor: UnitPoint = .center
    
    func body(content: Content) -> some View {
        content.scaleEffect(x: x, y: y, anchor: anchor)
    }
}

