//
//  DrawDemo.swift
//  Elevators
//
//  Created by Peter Larson on 6/24/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct DrawDemo: View {
    var body: some View {
        ZStack {
            Image(uiImage: Graphics.elevatorBackground(style: .demo))
                .resizable()
                .scaledToFit()
            Image(uiImage: Graphics.elevatorOverlay(style: .demo, percent: 0.0))
                .resizable()
                .scaledToFit()
        }
            .scaleEffect(0.5)
    }
}

struct DrawDemo_Previews: PreviewProvider {
    static var previews: some View {
        DrawDemo()
    }
}
