//
//  DemoView.swift
//  Elevators
//
//  Created by Peter Larson on 4/18/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct DemoView: View {
    
    @State var isShowing: Bool = false

    func titleTransition(height: CGFloat) -> AnyTransition {
        let insert = AnyTransition.offset(y: height / 5).combined(with: .opacity)
        let removal = AnyTransition.offset(y: -height / 5).combined(with: .opacity)
        return .asymmetric(insertion: insert, removal: removal)
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Button("show") {
                    withAnimation(Animation.easeOut(duration: Game.floorSpeed)) {
                        self.isShowing.toggle()
                    }
                }
                
                Color(red: 162/255, green: 248/255, blue: 241/255)
                    .opacity(self.isShowing ? 1 : 0)
                    .animation(.linear)
                if self.isShowing {
                    GameTitle("Elevators")
                        .transition(self.titleTransition(height: proxy.size.height))
                        .onAppear {
                            withAnimation(Animation.easeIn(duration: Game.floorSpeed).delay(0.3)) {
                                self.isShowing.toggle()
                            }
                    }
                } else {
                    /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                }
            }.edgesIgnoringSafeArea(.all)
        }
    }
}

struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView()
    }
}
