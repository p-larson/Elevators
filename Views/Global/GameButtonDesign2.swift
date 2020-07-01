//
//  GameButtonDesign2.swift
//  Elevators
//
//  Created by Peter Larson on 6/24/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct GameButtonDesign2<Content>: View where Content: View {
    
    let content: () -> Content
    
    @inlinable public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var background: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.black.opacity(0.2))
                .blendMode(.plusDarker)
//            RoundedRectangle(cornerRadius: 16)
//                .stroke(lineWidth: 5)
//                .foregroundColor(.white)
//                .blendMode(.saturation)
        }
    }
    
    var body: some View {
        let content = self.content()
        
        return content
            .padding(16)
            .background(background)
         
    }
}

struct GameButtonDesign2_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            
            HStack {
                GameButtonDesign2 {
                    Image("replay")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(1)
                }
                .frame(width: 70, height: 70)
                GameButtonDesign2 {
                    Image("replay")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(1)
                }
                .frame(width: 70, height: 70)
            }
            
        }
    }
}
