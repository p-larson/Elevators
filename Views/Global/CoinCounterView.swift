//
//  OverlayDisplayView.swift
//  Elevators
//
//  Created by Peter Larson on 5/20/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI
import MovingNumbersView

struct BuckCounterView: View {
    
    static let length: CGFloat = 24
    
    @ObservedObject var storage = GameData
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                HStack(spacing: 0) {
                    Text("$")
                        .font(.system(size: 16))
                    MovingNumbersView(number: Double(storage.buck), numberOfDecimalPlaces: 0, animationDuration: 0.3) { string in
                        Text(string)
                            .fixedSize()
                    }
                    .mask(LinearGradient(
                        gradient: Gradient(stops: [
                            Gradient.Stop(color: .clear, location: 0),
                            Gradient.Stop(color: .black, location: 0.2),
                            Gradient.Stop(color: .black, location: 0.8),
                            Gradient.Stop(color: .clear, location: 1.0)]),
                        startPoint: .top,
                        endPoint: .bottom))
                    .font(.custom("Futura", size: 24))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(Capsule().foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.15), radius: 0, x: 0, y: 5))
            }
            .frame(height: 32)
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .foregroundColor(.black)
    }
}

struct BuckCounterTestView: View {
    
    var body: some View {
        ZStack {
            BuckCounterView()
            HStack {
                Button("+") {
                    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { (timer) in
                        if GameData.buck < 1000 {
                            GameData.buck += .random(in: 1 ..< 100)
                        } else {
                            timer.invalidate()
                        }
                    }
                }
            }
        }
    }
}

struct BuckCounterPreviews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            BuckCounterTestView()
        }.previewDevice("iPhone 11")
    }
}
