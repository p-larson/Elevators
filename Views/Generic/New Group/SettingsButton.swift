//
//  SettingsButton.swift
//  Elevators
//
//  Created by Peter Larson on 4/6/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct SettingsButton: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.15), radius: 0, x: 0, y: 10)
            Circle()
                .padding(5)
            GeometryReader { reader in
                Path { path in
                    let center = CGPoint(x: reader.size.width / 2, y: reader.size.height / 2)
                    let radius = min(reader.size.width, reader.size.height) / 5 * 3
                    for angle in stride(from: 0.0, to: CGFloat.pi * 2, by: CGFloat.pi / 4) {
                        path.move(to: center)
                        path.addLine(to:
                            CGPoint(
                                x: cos(angle) * radius + reader.size.width / 2,
                                y: sin(angle) * radius + reader.size.height / 2
                            )
                        )
                    }
                }
                .stroke(style:
                    StrokeStyle(
                        lineWidth: min(reader.size.width, reader.size.height) / 5,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                    .foregroundColor(.white)
            }
            .padding(15)
            Circle()
                .padding(15)
                .foregroundColor(.white)
            Circle()
                .padding(22.5)
        }
    }
}

struct SettingsButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("background")
            SettingsButton()
                .foregroundColor(Color(#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)))
                .frame(width: 50, height: 50)
        }.edgesIgnoringSafeArea(.all)
    }
}
