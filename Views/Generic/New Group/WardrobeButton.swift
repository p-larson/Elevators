//
//  WardrobeButton.swift
//  Elevators
//
//  Created by Peter Larson on 4/7/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct WardrobeButton: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.15), radius: 0, x: 0, y: 10)
            Circle()
                .padding(5)
            GeometryReader { reader in
                Path { path in
                    path.addLines(
                        [
                            .init(x: 32.5, y: 27.5),
                            .init(x: 7.5, y: 27.5),
                            .init(x: 20, y: 20),
                            .init(x: 32.5, y: 27.5)
                        ]
                    )
                    path.move(to: .init(x: 20, y: 20))
                    path.addLines(
                        [
                            .init(x: 20, y: 20),
                            .init(x: 20, y: 12.5),
                            .init(x: 15, y: 15)
                        ]
                    )
                }
                .strokedPath(StrokeStyle(lineWidth: reader.size.width / 8, lineCap: .round, lineJoin: .round)).foregroundColor(.white)
                .scaleEffect(x: reader.size.width / 50, y: reader.size.height / 50, anchor: .center)
                .scaledToFit()
            }.padding(5)
        }
    }
}

struct WardrobeButton_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeButton()
            .frame(width: 50, height: 50)
    }
}
