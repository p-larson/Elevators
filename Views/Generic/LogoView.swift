//
//  LogoView.swift
//  Elevators
//
//  Created by Peter Larson on 4/8/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                VStack {
                    Text("Larson")
                        .font(.custom("Futura-Bold", size: 32))
                        .frame(width: 200)
                    Text("Software")
                        .font(.custom("Futura-Medium", size: 16))
                }.foregroundColor(.white).frame(width: 200)
            }.frame(width: 200, height: 80)
        }
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
