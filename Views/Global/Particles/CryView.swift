//
//  CryView.swift
//  Elevators
//
//  Created by Peter Larson on 5/24/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct CryView: View {
    
    var isEmitting: Bool
    
    let cry = Graphics.cry()

    var body: some View {
        ZStack {
            if self.isEmitting {
                ParticlesEmitter {
                    EmitterCell()
                        .content(.image(cry))
                        .lifetime(10)
                        .birthRate(10)
                        .alphaSpeed(-0.125)
                        .scale(0.75)
                        .scaleRange(-0.25)
                        .velocity(150)
                        .velocityRange(50)
                        .yAcceleration(5)
                        .emissionLongitude(.pi)
                }
                .emitterShape(.line)
                .emitterPosition(CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / -4))
                .emitterSize(UIScreen.main.bounds.size)
            }
        }
            .frame(minWidth: 0, maxWidth: .infinity)
        .transition(.scale)
        .animation(.linear)
        .allowsHitTesting(false)
    }
}

struct CryTestView: View {
    @State var isEmitting = true
    
    var body: some View {
        ZStack {
            CryView(isEmitting: isEmitting)
            Button("Toggle") {
                self.isEmitting.toggle()
            }
        }
    }
}

struct CryView_Previews: PreviewProvider {
    static var previews: some View {
        CryTestView()
    }
}
