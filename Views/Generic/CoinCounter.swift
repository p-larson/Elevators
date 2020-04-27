//
//  CoinCounter.swift
//  Elevators
//
//  Created by Peter Larson on 4/8/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct CoinCounter: View {
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Path { path in
                    let circle = CGRect(x: 0, y: 0, width: reader.size.height, height: reader.size.height)
                    let rect = CGRect(x: 0, y: reader.size.height / 2 - reader.size.height / 3, width: reader.size.width, height: reader.size.height / 3 * 2)
                    path.addEllipse(in: circle)
                    path.addRoundedRect(in: rect, cornerSize: CGSize(width: 16, height: 16))
                }.shadow(color: Color.black.opacity(0.15), radius: 0, x: 0, y: 10).foregroundColor(.white)
                CoinView().padding(5).position(x: reader.size.height / 2, y: reader.size.height / 2)
                HStack {
                    Spacer()
                    Text("10,000")
                        .font(.custom("Futura-Bold", size: reader.size.height / 3))
                    .foregroundColor(Color("Gold"))
                }.padding(.horizontal, 5)
            }
        }
    }
}

struct CoinCounter_Previews: PreviewProvider {
    static var previews: some View {
        CoinCounter()
            .frame(width: 90, height: 40)
    }
}
