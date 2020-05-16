//
//  LazyView.swift
//  Elevators
//
//  Created by Peter Larson on 5/14/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let content: () -> Content
    
    init(_ content: @autoclosure @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
    }
}

extension View {
    func lazy() -> some View {
        LazyView(self)
    }
}

struct LazyView_Previews: PreviewProvider {
    static var previews: some View {
        Text("demo").lazy()
    }
}
