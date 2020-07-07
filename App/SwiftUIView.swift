//
//  SwiftUIView.swift
//  Elevators
//
//  Created by Peter Larson on 7/1/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct SwiftUIView: View {
    
    @State var isShowing = false
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all).onTapGesture {
                self.isShowing = true
            }
            .zIndex(1)
            
            if isShowing {
                SwiftUI2View(isShowing: $isShowing)
                    .zIndex(2)
            }
        }
        .animation(.linear(duration: 0.3), value: isShowing)
    }
}

struct SwiftUI2View: View {
    @Binding var isShowing: Bool
    
    @State var value = false
    
    var body: some View {
        VStack(spacing: 0) {
            Color.blue.onTapGesture {
                self.value.toggle()
            }
            .frame(height: value ? 50 : 100)
            Color.red.onTapGesture {
                self.isShowing = false
            }
        }
        .transition(.move(edge: .bottom))
        .animation(.linear(duration: 0.15), value: value)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
