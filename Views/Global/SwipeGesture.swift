//
//  SwipeGesture.swift
//  Elevators
//
//  Created by Peter Larson on 5/27/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct SwipeGesture: Gesture {
    
    let direction: Direction
    
    enum Direction {
        case left, right, up, down
        
        func translation(_ value: DragGesture.Value) -> CGFloat {
            switch self {
            case .left, .right:
                return abs(value.translation.width)
            case .up, .down:
                return abs(value.translation.height)
            }
        }
    }
    
    var body: some Gesture {
        DragGesture(
            minimumDistance: CGFloat(UIScreen.main.bounds.width / 25),
            coordinateSpace: .local
        ).onChanged({ (value) in
            print(self.direction.translation(value))
        })
    }
}

struct SwipeGesturePreviews: PreviewProvider {
    static var previews: some View {
        Color.red.gesture(SwipeGesture(direction: .left))
    }
}
