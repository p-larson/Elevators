//
//  JitterModifier.swift
//  Elevators
//
//  Created by Peter Larson on 6/30/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct NotificationModifier: ViewModifier {
    let delay: TimeInterval
    let duration: TimeInterval
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                
            }
    }
}
