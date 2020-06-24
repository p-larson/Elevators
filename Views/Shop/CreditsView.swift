//
//  CreditsView.swift
//  Elevators
//
//  Created by Peter Larson on 5/26/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct Credit: Identifiable {
    let description: String
    let name: String
    let username: String
    
    var id: String {
        return name
    }
}

struct CreditsView: View {
    
    @Binding var isShowing: Bool
    
    @ObservedObject var storage = Storage.current
    
    let credits = [
        Credit(description: "Designed and Developed by", name: "Peter Larson", username: "p.larson"),
        Credit(description: "Visually Designed by", name: "Evan Usem", username: "evanusem"),
        Credit(description: "Music by", name: "?", username: "unknown"),
        Credit(description: "Special thanks to our publisher \nfor helping get our game into your hands. We love you guys :)", name: "Ketchapp Studios", username: "ketchapp")
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 8) {
                Spacer()
                GameTitle("Elevators", dark: true)
                HStack {
                    Text("Credits")
                        .font(.custom("Futura", size: 24))
                    Spacer()
                    Text("\(storage.credits.count)/\(credits.count) Collected")
                }
                ForEach(self.credits, id: \.id) { credit in
                    HStack {
                        Text(credit.description)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.gray)
                        Spacer()
                        InstagramButton(
                            credit.name,
                            credit.username,
                            collected: self.storage.credits.contains(credit.username)
                        )
                    }
                }
                Text("Credit rewards reset every week and are worth 25 coins each.\nPlease enjoy these gifts, thank you for downloading our app,\nIt has been our pleasure to create this game for you.")
                    .foregroundColor(.gray)
                    .padding(.top, 4)
                    .font(.custom("Futura", size: 10))
                    .multilineTextAlignment(.center)
                    .opacity(0.5)
                Spacer()
                Button("Done") {
                    self.isShowing = false
                }
            }
            .foregroundColor(.white)
            .font(.custom("Futura", size: 12))
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(32)
            .onAppear {
                self.storage.checkCreditsRewards()
            }
        }
    }
}
struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView(isShowing: .constant(false))
            .statusBar(hidden: true)
    }
}
