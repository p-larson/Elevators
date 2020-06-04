//
//  DailyPrizeView.swift
//  Elevators
//
//  Created by Peter Larson on 5/20/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct DailyPrizeView: View {
    
    let currentStreak: Int = .random(in: 0 ..< 5)
    let prize: Int = 10
    
    @State var claimed: Bool = false
    @Binding var isShowing: Bool
    
    func corners(_ offset: Int) -> UIRectCorner {
        switch offset {
        case 1:
            return [.topLeft, .bottomLeft]
        case 5:
            return [.topRight, .bottomRight]
        default:
            return .allCorners
        }
    }
    
    func color(_ offset: Int) -> Color {
        
        let day = currentStreak / 5 + offset
        
        if day < currentStreak || (claimed && day == currentStreak) {
            return Color("theme-1")
        } else if day == currentStreak {
            return Color("theme-1").opacity(0.2)
        } else if day % 5 == 0 {
            return Color.purple.opacity(0.2)
        } else {
            return Color.gray.opacity(0.2)
        }
    }
    
    var indicator: some View {
        HStack(spacing: 8) {
            ForEach(Range<Int>(1 ... 5)) { offset in
                VStack(spacing: 8) {
                    Text("Day \(self.currentStreak / 5 + offset)")
                    Rectangle()
                        .frame(height: 16)
                        .foregroundColor(self.color(offset))
                        .cornerRadius(
                            radius: offset == 1 || offset == 5 ? 16 : 0,
                            corners: self.corners(offset)
                    )
                }
            }
        }
    }
    
    var coins: some View {
        GeometryReader { proxy in
            ForEach(0 ..< 16) { i in
                Image("coin")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .position(self.positions[i])
            }
        }
    }
    
    let positions = [
        CGPoint(x: 57, y: 149),
        CGPoint(x: 81, y: 79),
        CGPoint(x: 139, y: 126),
        CGPoint(x: 165, y: 171),
        CGPoint(x: 163, y: 57),
        CGPoint(x: 92, y: 78),
        CGPoint(x: 162, y: 132),
        CGPoint(x: 91, y: 179),
        CGPoint(x: 192, y: 189),
        CGPoint(x: 127, y: 82),
        CGPoint(x: 192, y: 87),
        CGPoint(x: 133, y: 194),
        CGPoint(x: 185, y: 85),
        CGPoint(x: 154, y: 111),
        CGPoint(x: 95, y: 129),
        CGPoint(x: 82, y: 139),


    ]
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(self.prize) Coins!")
                .foregroundColor(Color("Coin"))
            self.coins
                .frame(width: 250, height: 250)
                .zIndex(1)
            GameButton {
                Text("Claim")
                    .foregroundColor(.white)
            }
            .foregroundColor(Color("theme-1"))
            .onButtonPress {
                withAnimation {
                    self.claimed = true
                    self.isShowing = false
                    Storage.current.coins += .random(in: 1 ..< 5)
                }
            }
            .zIndex(1)
            self.indicator
                .padding(.top, 32)
            Spacer()
        }
        .font(.custom("Futura Bold", size: 24))
        .padding()
        .background(Color.white)
    }
}

struct DailyPrizeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            DailyPrizeView(isShowing: .constant(false))
        }
    }
}
