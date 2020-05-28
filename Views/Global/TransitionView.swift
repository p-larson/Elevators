//
//  TransitionView.swift
//  Elevators
//
//  Created by Peter Larson on 5/21/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct TransitionView: View {
    
    @State var animating = false
    @Binding var showTransition: Bool
    @Binding var isTransitioning: Bool
    @Binding var perform: (() -> Void)?
    
    var body: some View {
        ZStack {
            GameBackground()
            if animating {
                GameTitle("Elevators", dark: false)
                    .transition(
                        AnyTransition.asymmetric(
                            insertion: AnyTransition.move(edge: .bottom).combined(with: .opacity)
                                .animation(Animation.easeIn(duration: 0.3)),
                            removal: AnyTransition.move(edge: .top).combined(with: .opacity)
                                .animation(Animation.easeIn(duration: 0.3))
                        )
                    )
                    .zIndex(6)
            }
        }.onAppear {
            self.animating = true
            self.isTransitioning = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                if self.animating {
                    withAnimation {
                        self.animating = false
                    }
                }
                
                self.perform?()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showTransition = false
            }
        }.onDisappear {
            self.isTransitioning = false
        }
    }
}

struct TransitionTestView: View {
    
    @State var showTransition = false
    @State var isTransitioning = false
    @State var transition: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            VStack {
                Button("Demo") {
                    withAnimation {
                        self.showTransition = true
                    }
                }
                .disabled(self.isTransitioning)
                
                Button("1") {
                    self.transition = {
                        print("1")
                    }
                }
                
                Button("2") {
                    self.transition = {
                        print("2")
                    }
                }
            }
            
            if showTransition {
                TransitionView(
                    showTransition: self.$showTransition,
                    isTransitioning: self.$isTransitioning,
                    perform: self.$transition
                )
                    .zIndex(5)
            }
        }
        .animation(.linear)
        .transition(.opacity)
        .onAppear {
            self.transition = {
                print("asb")
            }
        }

    }
}

struct TransitionView_Previews: PreviewProvider {
        
    static var previews: some View {
        TransitionTestView()
    }
}
