//
//  Background.swift
//  Elevators
//
//  Created by Peter Larson on 5/21/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct GameBackground: ViewModifier {
    func body(content: Content) -> some View {
        content.background(
            LinearGradient(
                gradient: Gradient(colors: [Color("theme-1"), Color("theme-2")]),
                startPoint: .top,
                endPoint: .bottom
            ).edgesIgnoringSafeArea(.all)
        )
    }
}
struct Background_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
            .modifier(GameBackground())
    }
}
