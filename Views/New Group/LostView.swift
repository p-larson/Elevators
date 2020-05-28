//
//  LostView.swift
//  Elevators
//
//  Created by Peter Larson on 5/23/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct LostView: View {
        
    var body: some View {
        VStack(spacing: 8) {
            Text("Level Lost")
                .foregroundColor(.white)
                .font(.custom("Futura", size: 48))
                .padding(.top, UIScreen.main.bounds.height / 4)
            
            GameButton {
                HStack {
                    Spacer()
                    Image("watch-video")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .brightness(-1)
                    Text("Watch Ad for 50 Coins")
                        .foregroundColor(.black)
                        .transition(.slide)
                    Spacer()
                }
                
            }
            .foregroundColor(.white)
            GameButton {
                HStack {
                    Spacer()
                    Image("replay")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .brightness(-1)
                    Text("Retry")
                        .foregroundColor(.black)
                    Spacer()
                }
            }
            Spacer()
        }
        .foregroundColor(.white)
        .font(.custom("Futura Condensed Medium", size: 32))
        .doesButtonScale(enabled: false)
        .buttonCornerRadius(0.0)
        .animation(.easeInOut(duration: 0.2))
        .transition(AnyTransition.scale.combined(with: .opacity))
    }
}

struct LoserTestView: View {
    
    @State var show = true
    
    var body: some View {
        ZStack {
            Button("Toggle") {
                withAnimation {
                    self.show.toggle()
                }
            }.padding(.top, 250)
            
            if show {
                LostView()
            }
        }
    }
}

struct LostView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            LoserTestView()
            CoinCounterView()
        }
    }
}
