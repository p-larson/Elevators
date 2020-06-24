//
//  LoadingView.swift
//  Elevators
//
//  Created by Peter Larson on 6/23/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

public struct LoadingCompletionKey: EnvironmentKey {
    public static let defaultValue: (() -> Void)? = nil
}

public extension EnvironmentValues {
    var loadingCompletionHandler: (() -> Void)? {
        get {
            return self[LoadingCompletionKey.self]
        }
        
        set {
            self[LoadingCompletionKey.self] = newValue
        }
    }
}

public extension View {
    @inlinable func onLoadingCompletion(_ handler: @escaping () -> Void) -> some View {
        self.environment(\.loadingCompletionHandler, handler)
    }
}

struct LoadingView: View {
    
    @State var frame = 1
    @State var isPresenting = false
    @Binding var isShowing: Bool
    
    @Environment(\.loadingCompletionHandler) var completion
    
    func logo() -> some View {
        Image("cornpopstudios.\(frame)")
            .resizable()
            .scaledToFit()
    }
    
    
    var body: some View {
        ZStack {
            Color("theme-1")
                .edgesIgnoringSafeArea(.all)
            if self.isPresenting {
                self.logo()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            Timer.scheduledTimer(withTimeInterval: 1.0 / 24.0, repeats: true) { (timer) in
                                if self.frame < 68 {
                                    self.frame += 1
                                } else if self.frame == 68 {
                                    self.isPresenting = false
                                }
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 + 68 * (1.0 / 24.0)) {
                            withAnimation {
                                self.isShowing = false
                                self.completion?()
                            }
                        }
                        
                    })
                    .zIndex(1)
                    .transition(.opacity)
                    .animation(.linear(duration: 0.3))
            }
        }.onAppear {
            self.isPresenting = true
        }
    }
}

struct LoadingTestView: View {
    @State var isShowing = false
    
    var body: some View {
        ZStack {
            
            Button("show") {
                self.isShowing = true
            }
            .zIndex(1)
            
            if isShowing {
                LoadingView(isShowing: $isShowing)
                    .transition(.opacity)
                    .animation(.linear(duration: 0.3))
                    .zIndex(2)
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingTestView()
            .previewDevice("iPhone X")
    }
}
