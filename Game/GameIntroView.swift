//
//  GameIntroView.swift
//  Elevators
//
//  Created by Peter Larson on 4/28/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct GameIntroView: View {
    var body: some View {
        VStack {
            Spacer()
            GameTitle.init("Elevators", dark: false)
            GameText("Tap to Start")
        }.padding(.bottom, 300).foregroundColor(.white).contentShape(Rectangle())
    }
}

struct GameIntroView_Previews: PreviewProvider {
    static var previews: some View {
        GameIntroView()
            .edgesIgnoringSafeArea(.all)
            .background(Color.blue)
    }
}
