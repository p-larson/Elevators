//
//  UnlockElevatorView.swift
//  Elevators
//
//  Created by Peter Larson on 5/28/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct UnlockElevatorView: View {
    
    var body: some View {
        ZStack {
            Image(uiImage: Graphics.elevatorBackground(style: .demo))
                .resizable()
            Image(uiImage: Graphics.elevatorOverlay(style: .demo, percent: 0.0))
                .resizable()
        }
        .scaledToFit()
        .frame(width: UIScreen.main.bounds.width / 4)
    }
}

struct UnlockElevatorView_Previews: PreviewProvider {
    static var previews: some View {
        UnlockElevatorView()
    }
}
