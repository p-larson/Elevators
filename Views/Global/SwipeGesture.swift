//
//  SwipeGesture.swift
//  Elevators
//
//  Created by Peter Larson on 5/27/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct SwipeView: View {
    
    var swipes: some Gesture {
        DragGesture()
        .onChanged({ value in
            value.
        })
    }
    
    var body: some View {
        Color.red.edgesIgnoringSafeArea(.all)
            .gesture(swipes)
    }
}

struct SwipeGestureTestView: PreviewProvider {
    static var previews: some View {
        SwipeGesture()
    }
}
