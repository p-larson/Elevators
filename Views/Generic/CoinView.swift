//
//  CoinView.swift
//  Elevators
//
//  Created by Peter Larson on 4/8/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct CoinView: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color("Gold2"))
            Circle().padding(5)
                .foregroundColor(Color("Gold"))
            Text("C")
                .foregroundColor(Color("Gold2"))
                .font(.custom("Futura-Bold", size: 1000))
                .scaledToFit()
                .minimumScaleFactor(0.0001)
                .lineLimit(1)
        }
    }
}

struct CoinView_Previews: PreviewProvider {
    static var previews: some View {
        CoinView()
            .frame(width: 50, height: 50)
    }
}
