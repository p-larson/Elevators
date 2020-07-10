//
//  ConfettiView.swift
//  Elevators
//
//  Created by Peter Larson on 5/22/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import UIKit
import SwiftUI

struct ConfettiView: View {
    
    var isEmitting: Bool
    
    let intensity: Float = 0.65
    
    let colors = [
        UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
        UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
        UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
        UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
        UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)
    ]
    
    var body: some View {
        ZStack {
            if self.isEmitting {
                
                ParticlesEmitter {
                    self.colors.map { color in
                        let confetti = EmitterCell().content(.image(UIImage(named: "confetti")!))
                        
                        confetti.birthRate = 6.0 * intensity
                        confetti.lifetime = 14.0 * intensity
                        confetti.lifetimeRange = 0
                        confetti.color = color.cgColor
                        confetti.velocity = CGFloat(350.0 * intensity)
                        confetti.velocityRange = CGFloat(80.0 * intensity)
                        confetti.emissionLongitude = CGFloat(Double.pi)
                        confetti.emissionRange = CGFloat(Double.pi)
                        confetti.spin = CGFloat(3.5 * intensity)
                        confetti.spinRange = CGFloat(4.0 * intensity)
                        confetti.scaleRange = CGFloat(intensity)
                        confetti.scaleSpeed = CGFloat(-0.1 * intensity)
                        
                        return confetti
                    }
                }
                .emitterShape(.line)
                .emitterPosition(CGPoint(x: UIScreen.main.bounds.width / 2, y: 0))
            }
        }
        .transition(.scale)
        .animation(.linear)
        .allowsHitTesting(false)
    }
}

struct ConfettiTestView: View {
    @State var isEmitting = true
    
    var body: some View {
        ZStack {
            ConfettiView(isEmitting: isEmitting)
            Button("Toggle") {
                self.isEmitting.toggle()
            }
        }
    }
}

struct ConfettiView_Previews: PreviewProvider {
    static var previews: some View {
        ConfettiTestView()
    }
}
