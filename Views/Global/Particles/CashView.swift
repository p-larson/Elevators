//
//  CryView.swift
//  Elevators
//
//  Created by Peter Larson on 5/24/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct CashView: View {
    
    @State private var show = false
    
    let cash = Graphics.cash(), intensity: Float = 0.9
    
    var body: some View {
        ParticlesEmitter {
            EmitterCell()
                .content(.image(cash))
                .birthRate(50.0)
                .lifetime(14.0)
                .color(.systemGreen)
                .velocity(CGFloat(350.0))
                .velocityRange(CGFloat(80))
                .emissionLongitude(.pi)
                .emissionRange(.pi)
                .spin(.pi / 4)
                .spinRange(CGFloat(4.0))
                .scaleSpeed(CGFloat(-0.1 * intensity))
                .scaleRange(0.5)
                .alphaRange(0.5)
        }
        .emitterShape(.line)
        .emitterPosition(CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / -4))
        .emitterSize(UIScreen.main.bounds.size)
        .frame(minWidth: 0, maxWidth: .infinity)
        .allowsHitTesting(false)
        .opacity(show ? 1 : 0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.show = true
            }
        }
    }
}

struct CryTestView: View {
    @State var isEmitting = true
    
    var body: some View {
        ZStack {
            CashView()
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
