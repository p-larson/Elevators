//
//  MovementDemo.swift
//  Elevators
//
//  Created by Peter Larson on 6/23/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct MovementDemo: View {
    
    @State var moving: Bool = false
    
    var body: some View {
        Image("strawberry-idle-10")
            .scaleEffect(x: 1, y: moving ? 0.5 : 1, anchor: .bottom)
            .onTapGesture {self.moving.toggle() }
    }
}

struct MovementDemo_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("main").edgesIgnoringSafeArea(.all)
            
            MovementDemo()
        }
    }
}
