//
//  RadialStripe.swift
//  Elevators
//
//  Created by Peter Larson on 4/7/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct RadialStripes: ViewModifier {
    
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
            }.blendMode(.darken).opacity(0.01)
        }
    }
    
    func body(content: Content) -> some View {
        content.overlay(stripes)
    }
}

struct RadialStripe_Previews: PreviewProvider {
    
    static let colors = [
        Color(red: 219/255, green: 235/255, blue: 237/255)
    ]
    
    static var previews: some View {
        Group {
            colors[0].edgesIgnoringSafeArea(.all).modifier(RadialStripes())
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: .bottom,
                endPoint: .top
            )
        }
    }
}
