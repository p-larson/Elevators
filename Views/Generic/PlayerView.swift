//
//  PlayerView.swift
//  Elevators
//
//  Created by Peter Larson on 4/8/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct PlayerView: View {
    
    @State var image = "chef.idle.right.1"
    
    func gif() {
        
        var frame = 1
        
        Timer.scheduledTimer(withTimeInterval: 1.0 / 16.0, repeats: true) { (timer) in
            if frame < 14 {
                frame+=1
            } else {
                frame = 1
            }
            
            self.image = "chef.idle.right.\(frame)"
        }
    }
    
    var body: some View {
        Image(self.image)
            .resizable()
            .onAppear(perform: gif)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
            .frame(width: 75, height: 130)
    }
}
