//
//  GameBackground.swift
//  Elevators
//
//  Created by Peter Larson on 5/21/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct GameBackground: View {
    var body: some View {
//        LinearGradient(
//            gradient: Gradient(colors: [Color("theme-1"), Color("theme-2")]),
//            startPoint: .top,
//            endPoint: .bottom
//        ).edgesIgnoringSafeArea(.all)
        
        Color("theme-1")
            .edgesIgnoringSafeArea(.all)
    }
}
struct Background_Previews: PreviewProvider {
    static var previews: some View {
        GameBackground()
    }
}
