//
//  LevelShareView.swift
//  Elevators
//
//  Created by Peter Larson on 5/15/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct LevelShareView: View {
    
    @ObservedObject var save = GameData
    @State var selection = Set<Int>()
    @State var share = false
    
    private var content: [NSURL] {
        self.selection.compactMap { (id) -> NSURL? in
            GameData.getFile(for: id)
        }
    }
    
    var body: some View {
        List(self.save.levels, id: \.id, selection: $selection) {
            model in
            Text(model.name)
        }
        .navigationBarTitle("Share", displayMode: .inline)
        .environment(\.editMode, .constant(EditMode.active))
        .overlay(
            VStack {
                Spacer()
                Button(action: {
                    self.share.toggle()
                }) {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                        .shadow(radius: 2.0)
                        .overlay(Text("Share").font(.system(size: 12, weight: .light, design: .monospaced)).foregroundColor(.accentColor))
                }
            }
        )
        .popover(isPresented: $share) {
            ActivityViewController(activityItems: self.content)
        }
    }
}

struct LevelShareView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LevelShareView()
        }
    }
}
