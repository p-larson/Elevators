//
//  GameTitle.swift
//  Elevators
//
//  Created by Peter Larson on 4/6/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct GameTitle: View {
    @State var string: String
    let dark: Bool
    
    init(_ string: String, dark: Bool = false) {
        self._string = State(initialValue: string)
        self.dark = dark
    }
    
    private var text: String {
        return " \(string) "
    }
    
    var body: some View {
        ZStack {
            Text(text)
                .font(.custom("Being Strong Shadow", size: 64))
                .foregroundColor(dark ? .black : .white)
                .shadow(color: Color.black.opacity(dark ? 0 : 0.15), radius: 0, x: 0, y: 10)
            Text(text)
                .font(.custom("Being Strong Regular", size: 64))
                .foregroundColor(dark ? .white : .black)
        }.frame(height: 64)
    }
}

struct GameTitle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GameTitle("Elevators")
        }
    }
}

