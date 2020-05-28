//
//  RadialStripe.swift
//  Elevators
//
//  Created by Peter Larson on 4/7/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct RadialStripes: ViewModifier {
    
    @State var animating = false
    
    var stripes: some View {
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
        
            .blendMode(.lighten)
            .opacity(0.02)
            .blur(radius: 5)
            .onAppear(perform: {
                withAnimation {
                    self.animating = true
                }
            })
            .rotationEffect(Angle.degrees(self.animating ? 0 : 30))
            .animation(Animation.linear(
                    duration: 1
            ).repeatForever(autoreverses: false), value: self.animating)
        }
    }
    
    func body(content: Content) -> some View {
        content.background(stripes)
    }
}

struct RadialStripe_Previews: PreviewProvider {
    
    static let colors = [
        Color(red: 219/255, green: 235/255, blue: 237/255)
    ]
    
    static var previews: some View {
        ZStack {
            GameBackground()
            
            Image("chef.idle.right.1")
                .modifier(RadialStripes())
        }
    }
}
