//
//  GameBackground.swift
//  Elevators
//
//  Created by Peter Larson on 4/6/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct GameBackground: ViewModifier {
    func body(content: Content) -> some View {
        content.background(Color("background").edgesIgnoringSafeArea(.all))
    }
}
