//
//  WinView.swift
//  Elevators
//
//  Created by Peter Larson on 5/22/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct WinView: View {
    
    @Binding var model: LevelModel
    
    var body: some View {
        VStack {
            Text("Level \(model.number) Complete!")
                .padding(.top, UIScreen.main.bounds.height / 4)
                .font(.custom("Futura Bold", size: 32))
            Text("Tap for Next 👉")
                .opacity(0.5)
            Spacer()
        }
        .foregroundColor(.white)
        .font(.custom("Futura Medium", size: 24))
        .transition(.scale)
        .animation(.linear)
    }
}

struct WinTestView: View {
    
    @State var model: LevelModel
    @State var hasWon = true
    
    var body: some View {
        ZStack {
            Button("Present") {
                withAnimation {
                    self.hasWon.toggle()
                }
            }
            
            if hasWon {
                WinView(model: $model)
            }
        }
    }
}

struct WinTestView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            WinTestView(model: .demo)
        }
    }
}
