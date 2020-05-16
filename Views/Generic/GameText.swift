//
//  GameText.swift
//  Elevators
//
//  Created by Peter Larson on 4/28/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct GameText: View {
    
    let string: String
    
    init(_ string: String) {
        self.string = string
    }
    
    var body: some View {
        Text(string)
            .font(.custom("Belligan", size: 24))
    }
}

struct GameText_Previews: PreviewProvider {
    static var previews: some View {
        GameText("Press to begin")
    }
}
