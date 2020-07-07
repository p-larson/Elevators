//
//  LoseView.swift
//  Elevators
//
//  Created by Peter Larson on 6/30/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct LoseView: View {
    
    @State var showSkip = false
    @State var showSkipLabel = false
    @State var showAd = false
    @State var showAdLabel = false
    
    var body: some View {
        VStack(spacing: 8) {
            GameButton {
                HStack {
                    Text("Skip Level ($200) ➞")
                        .foregroundColor(.white)
                }
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity)
                .offset(x: !self.showSkipLabel ? -UIScreen.main.bounds.width : 0, y: 0)
                .scaleEffect(self.showSkipLabel ? 1 : 1.3)
            }
            .foregroundColor(Color.green)
            .offset(x: !self.showSkip ? -UIScreen.main.bounds.width : 0, y: 0)
            .scaleEffect(x: 1, y: self.showSkip ? 1 : 0, anchor: .center)
            
            GameButton {
                HStack {
                    Image("ad")
                        .resizable()
                        .frame(width: 32, height: 32)
                    Text("Video Ad ($50)")
                }
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity)
                .offset(x: !self.showAdLabel ? -UIScreen.main.bounds.width : 0, y: 0)
                .scaleEffect(self.showAdLabel ? 1 : 1.3)
            }
            .foregroundColor(.purple)
            .offset(x: !self.showAd ? -UIScreen.main.bounds.width : 0, y: 0)
            .scaleEffect(x: 1, y: self.showAd ? 1 : 0, anchor: .center)
            
        }
        .font(.custom("Chalkboard SE Regular", size: 24))
        .buttonCornerRadius(0)
        .buttonHighlights(false)
        .buttonPadding(value: 0)
        .onAppear {
            withAnimation(Animation.linear(duration: 0.3)) {
                self.showSkip = true
            }
            
            withAnimation(Animation.interpolatingSpring(stiffness: 100, damping: 10).delay(0.3)) {
                self.showSkipLabel = true
            }
            
            withAnimation(Animation.linear(duration: 0.3).delay(0.3)) {
                self.showAd = true
            }
            
            withAnimation(Animation.interpolatingSpring(stiffness: 100, damping: 10).delay(0.6)) {
                self.showAdLabel = true
            }
        }
    }
}

struct LoseView_Previews: PreviewProvider {
    static var previews: some View {
        LoseView()
    }
}
