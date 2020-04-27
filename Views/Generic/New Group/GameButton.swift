//
//  GameButton.swift
//  Elevators
//
//  Created by Peter Larson on 4/8/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct GameButton: ViewModifier {
    
    @State var isPressing: Bool = false
    
    @Binding var isPressed: Bool
    
    var gesture: some Gesture {
        LongPressGesture(minimumDuration: 0)
            .onEnded { (value) in
                self.isPressing.toggle()
        }.sequenced(before: TapGesture()
            .onEnded({ (action) in
                self.isPressing.toggle()
                self.isPressed.toggle()
            }))
    }
        
    func body(content: Content) -> some View {
        content
            .gesture(self.gesture)
            .scaleEffect(self.isPressing ? 0.8 : 1)
            .animation(.easeInOut(duration:0.1))
    }
}

struct GameButton_Previews: PreviewProvider {
    static var previews: some View {
        Circle()
            .frame(width: 50, height: 50)
            .foregroundColor(.green)
            .modifier(GameButton(isPressed: .constant(false)))
    }
}
