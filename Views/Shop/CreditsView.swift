//
//  CreditsView.swift
//  Elevators
//
//  Created by Peter Larson on 5/26/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI



struct CreditsView: View {
    
    @Binding var isShowing: Bool
    
    let description = """
Thank you for downloading our app. We have enjoyed making this game for you, and are happy to have shared our content.

It has been our pleasure to make this game
for you to enjoy.

Thank you for being awesome, please enjoy
some free coins on us!
"""
    
    var body: some View {
        ZStack {
            Color("shop")
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 16) {
                Text("Credits")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.custom("Futura Medium", size: 32))
                Text(description)
                    .lineSpacing(8)
                Spacer()
                HStack {
                    Text("Designed and Developed by")
                    Spacer()
                }
                GameButton {
                    HStack {
                        Text("@p.larson")
                        Spacer()
                        Text("+50 Coins")
                    }
                    .foregroundColor(.black)
                        
                    .font(.custom("Futura Medium", size: 16))
                }
                
                HStack {
                    Text("Designed and Graphiced by")
                    Spacer()
                }
                GameButton {
                    HStack {
                        Text("@evanusem")
                        Spacer()
                        Text("-50 Coins")
                    }
                    .foregroundColor(.black)
                        
                    .font(.custom("Futura Medium", size: 16))
                }
                
                Spacer()
                
                Button("Done") {
                    
                }
                .brightness(-0.5)
                .opacity(0.5)
                .font(.custom("Futura Medium", size: 32))
            }
            .padding()
            .font(.custom("Futura Medium", size: 16))
            .foregroundColor(.white)
        }
    }
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView(isShowing: .constant(false))
            .statusBar(hidden: true)
    }
}
