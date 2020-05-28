//
//  SwipeHandler.swift
//  Elevators
//
//  Created by Peter Larson on 5/28/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI
import UIKit


// Wrapper for UISwipeGestureRecognizer and UILongPressGestureRecognizer.
// Used to operate controls onto GameScene.
struct ControlsView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    @EnvironmentObject var scene: GameScene
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        
        let swipe = UISwipeGestureRecognizer.Direction.self
        
        [(swipe.left, #selector(scene.left)), (swipe.right, #selector(scene.right))].forEach { (direction, handler) in
            let recognizer = UISwipeGestureRecognizer(target: self, action: handler)
            
            recognizer.direction = direction
            
            view.addGestureRecognizer(recognizer)
        }
        
        let hold = UILongPressGestureRecognizer(target: self, action: #selector(X.instance.hold))
        
        view.addGestureRecognizer(hold)
        
        view.backgroundColor = .black
        view.isUserInteractionEnabled = true
        view.isExclusiveTouch = true
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        return
    }
}

class X {
    static let instance = X()
    
    @objc func hold() {
        print("hold")
    }
}
