//
//  NodeTestView.swift
//  Elevators
//
//  Created by Peter Larson on 6/25/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SpriteKit

public class TestScene: SKScene {
    
    var node: ElevatorNode!
    
    public override func didMove(to view: SKView) {
        backgroundColor = .blue
        
        node = ElevatorNode(floor: 1, slot: 1, target: 1)
        
        node.position.x = frame.width / 2
        node.position.y = frame.height / 2
        
        self.addChild(node)
    }
    
    var opening = false
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if opening {
            node.waveClose()
            opening = false
        } else {
            node.open(animates: true)
            opening = true
        }
    }
}

import SwiftUI

public struct TestSceneView: UIViewRepresentable {
    public func makeUIView(context: Context) -> SKView {
        let view = SKView(frame: UIScreen.main.bounds)
        
        view.presentScene(TestScene(size: UIScreen.main.bounds.size))
        
        return view
    }
    
    public func updateUIView(_ uiView: SKView, context: Context) {
        return
    }
}

struct NodeTestView: View {
    var body: some View {
        TestSceneView()
            .edgesIgnoringSafeArea(.all)
    }
}

struct NodeTestView_Previews: PreviewProvider {
    static var previews: some View {
        
        TestSceneView()
            .edgesIgnoringSafeArea(.all)
    }
}
