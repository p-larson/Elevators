//
//  CharactersView.swift
//  Elevators
//
//  Created by Peter Larson on 4/8/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

let playerstyles = [Color.gray, Color.gray, Color.gray, Color.gray, Color.gray]

struct CharactersView: View {
    
    @Binding var open: Bool
    @State var offset = 0
    @State var selected = 0
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .frame(height: 50)
                    .foregroundColor(Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)))
                HStack {
                    Spacer()
                    Text("Characters")
                        .font(.custom("Belligan", size: 24))
                    Spacer()
                    Button("X") {
                        self.open.toggle()
                    }
                }.foregroundColor(.white).padding(.horizontal, 16)
            }
            ScrollView {
                EmptyView()
            }.frame(height: 400)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.15), radius: 0, x: 0, y: 10)
        .padding(.horizontal, 32)
        .font(.custom("Belligan", size: 20))
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView(open: .constant(false))
    }
}
