//
//  SettingsView.swift
//  Elevators
//
//  Created by Peter Larson on 4/8/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Binding var open: Bool
    @State var music: Bool = true
    @State var heptic: Bool = true
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .frame(height: 50)
                    .foregroundColor(Color(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)))
                HStack {
                    Spacer()
                    Text("Settings")
                        .font(.custom("Belligan", size: 24))
                    Spacer()
                    Button("X") {
                        self.open.toggle()
                    }
                }.foregroundColor(.white).padding(.horizontal, 16)
            }
            VStack {
                Toggle(isOn: $music) {
                    Text("Sound")
                }
                
                Toggle(isOn: $heptic) {
                    Text("Vibration")
                }
                
                LogoView()
                HStack {
                    Button("Legal") {
                        
                    }
                    Button("Restore Purchases") {
                        
                    }
                }.frame(width: 200)
                    .padding(.bottom, 20)
            }.padding(.horizontal, 20)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.15), radius: 0, x: 0, y: 10)
        .padding(.horizontal, 32)
        .font(.custom("Belligan", size: 20))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(open: .constant(true))
            .previewDevice("iPhone 11")
    }
}
