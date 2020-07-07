// This example view is suppose to demonstrate how to properly
// animate nested transitions in views.

import SwiftUI

private struct ExplicitTransitionModifier: ViewModifier {
    
    @State private var show = false
    
    func body(content: Content) -> some View {
        ZStack {
            if show {
                content
            }
        }.onAppear {
            self.show = true
        }
    }
}

public extension View {
    func explicit() -> some View {
        self.modifier(
            ExplicitTransitionModifier()
        )
    }
}

struct NestedTransitionsView: View {
    
    @State var show = false
    @State var show2 = false
    
    var body: some View {
        ZStack {
            if show {
                Color.red
                    .transition(.slide)
                    .animation(.linear(duration: 0.2))
            }
        }.onAppear {
            self.show = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.show2 = true
            }
        }
    }
}

struct NestedTransitionsView_Previews: PreviewProvider {
    static var previews: some View {
        NestedTransitionsView()
    }
}
