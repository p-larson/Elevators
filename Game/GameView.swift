//
//  LevelView.swift
//  Elevators
//
//  Created by Peter Larson on 4/20/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI
import SpriteKit

struct GameContainerView: UIViewRepresentable {
    typealias UIViewType = SKView
    
    let model: LevelModel
    
    var scene: GameScene {
        GameScene(model: model)
    }
    
    @Binding var isPlaying: Bool
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView(frame: UIScreen.main.bounds)
        
        view.showsNodeCount = true
        view.showsFPS = true
        view.showsLargeContentViewer = true
        view.presentScene(scene)
        view.ignoresSiblingOrder = false
        view.isAsynchronous = true
        // Let the user start the game
        view.isPaused = true
        view.isUserInteractionEnabled = false
        
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        uiView.isPaused = !isPlaying
        uiView.isUserInteractionEnabled = isPlaying
    }
}

struct GameView: View {
    
    @State var isPlaying: Bool = true
    @State var isAnimating: Bool = false
    
    let model: LevelModel
    
    var introTransition: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .leading),
            removal: .move(edge: .trailing)
        ).combined(with: .opacity).animation(.linear)
    }
    
    var body: some View {
        ZStack {
            GameContainerView(model: model, isPlaying: $isPlaying)
                .zIndex(0)
                .onAppear {
                    withAnimation(.linear) {
                        self.isPlaying.toggle()
                    }
                }
            
            if !isPlaying {
                GameIntroView()
                    .onTapGesture {
                        withAnimation(.linear) {
                            self.isPlaying.toggle()
                        }
                    }
                    .onAppear {
                        withAnimation(Animation.linear.repeatForever()) {
                            self.isAnimating = true
                        }
                    }
                    .onDisappear {
                        self.isAnimating = false
                    }
                    .zIndex(1)
                    .transition(introTransition)
                    .opacity(isAnimating ? 0.75 : 1.0)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameView(model: .demo)
            .previewDevice("iPhone X")
            .edgesIgnoringSafeArea(.all).statusBar(hidden: true)
    }
}

