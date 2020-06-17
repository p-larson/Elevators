//
//  RadialStripe.swift
//  Elevators
//
//  Created by Peter Larson on 4/7/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct RadialStripes: View {
    
    @State var animating = false
    
    func radial(_ length: CGFloat) -> some View {
        RadialGradient(
            gradient: Gradient(colors: [Color.white, Color.clear]),
            center: .center,
            startRadius: 0,
            endRadius: length
        )
    }
    
    var body: some View {
        GeometryReader { reader in
            Path { path in
                let center = CGPoint(x: reader.size.width / 2, y: reader.size.height / 2)
                let length = max(reader.size.width, reader.size.height)
                
                stride(from: 0.0, to: 360.0, by: 30.0).forEach { (angle) in
                    path.move(to: center)
                    path.addArc(
                        center: center,
                        radius: length,
                        startAngle: .degrees(angle),
                        endAngle: .degrees(angle + 15),
                        clockwise: false
                    )
                    path.closeSubpath()
                }
            }
            .foregroundColor(.white)
            .blendMode(.saturation)
            .onAppear(perform: {
                withAnimation {
                    self.animating = true
                }
            })
            .rotationEffect(Angle.degrees(self.animating ? 0 : 30))
            .animation(Animation.linear(
                    duration: 1
            )
            .repeatForever(autoreverses: false), value: self.animating)
            .mask(self.radial(max(reader.size.height, reader.size.width) / 2))
        }.edgesIgnoringSafeArea(.all)
    }
}

struct RadialStripe_Previews: PreviewProvider {
    
    static let colors = [
        Color(red: 219/255, green: 235/255, blue: 237/255)
    ]
    
    static var previews: some View {
        ZStack {
            GameBackground()
            RadialStripes()
            Image("chef.idle.right.1")
        }
    }
}
