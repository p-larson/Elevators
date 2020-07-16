//
//  InstagramButton.swift
//  Elevators
//
//  Created by Peter Larson on 6/15/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct InstagramButton: View {
    
    @State var showAlternative = false
    
    let label: String
    let username: String
    let collected: Bool
    
    init(_ label: String, _ username: String, collected: Bool) {
        self.label = label
        self.username = username
        self.collected = collected
    }
    
    var background: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(lineWidth: 2.5)
            .foregroundColor(collected ? .clear : .white)
    }
    
    var body: some View {
        Button(action: {
            let link = URL(string: "instagram://user?username=\(self.username)")!
            
            if UIApplication.shared.canOpenURL(link) {
                UIApplication.shared.open(link, options: [:], completionHandler: nil)
            } else {
                self.showAlternative = true
            }
            
            if !self.collected {
                GameData.collect(self.username)
            }
        }) { // Label
            Text(label)
                .padding(.vertical, 8)
                .frame(width: 110)
                .transition(.opacity)
                .background(background)
                .sheet(isPresented: $showAlternative) {
                    WebView(url: "https://www.instagram.com/\(self.username)")
            }
        }
    }
}

struct InstagramButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            HStack {
                Text("Designed and Programmed by")
                    .foregroundColor(.gray)
                InstagramButton("Peter Larson", "p.larson", collected: false)
                    .foregroundColor(.white)
            }
            .font(.custom("Futura", size: 16))
            .padding(.horizontal, 16)
        }
    }
}
