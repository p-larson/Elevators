//
//  ElevatorsOverlayView.swift
//  Elevators
//
//  Created by Peter Larson on 4/18/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct ElevatorsOverlayView: View {
    
    @Binding private var presented: Bool
    @State private var animating: Bool = false
    
    init(presented value: Binding<Bool>) {
        self._presented = value
    }
    
    private var background: AnyTransition {
        return AnyTransition.opacity.animation(.linear(duration: 2.0))
    }
    
    var body: some View {
        ZStack {
            Color(red: 162/255, green: 248/255, blue: 241/255)
                .edgesIgnoringSafeArea(.all)
                .transition(background)
            GameTitle("Elevators")
                .transition(.slide)
                
        }
    }
}

struct ElevatorsOverlayView_Previews: PreviewProvider {
    
    @State public static var showing: Bool = false
    
    static var previews: some View {
        ZStack {
            ElevatorsOverlayView(presented: .constant(false))
                .animation(Animation.linear(duration: 0.3).delay(0.5))
        }
    }
}
