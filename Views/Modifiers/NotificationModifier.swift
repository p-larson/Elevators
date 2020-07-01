//
//  NotificationModifier.swift
//  Elevators
//
//  Created by Peter Larson on 6/30/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct NotificationModifier: ViewModifier {
    // Total delay before next notification animation
    let delay: TimeInterval
    let duration: TimeInterval
    
    @Binding var isEnabled: Bool
    
    @State private var scaled = false
    
    func startAnimating() {
        
        assert(duration / 2 < delay, "Delay cannot be less than the animation's duration!")
        
        Timer.scheduledTimer(withTimeInterval: self.delay, repeats: true) { (timer) in
            // Ignore if not enabled.
            if !self.isEnabled {
                return
            }
            // Animate scale
            self.scaled.toggle()
            // Revert animation after duration
            DispatchQueue.main.asyncAfter(deadline: .now() + self.duration, execute: {
                self.scaled.toggle()
            })
        }
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear(perform: startAnimating)
            .scaleEffect(scaled ? 1.2 : 1)
            .animation(.linear(duration: duration / 2))
        
    }
}
