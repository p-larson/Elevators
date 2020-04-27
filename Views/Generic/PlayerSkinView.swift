////
////  PlayerSkinView.swift
////  Elevators
////
////  Created by Peter Larson on 4/8/20.
////  Copyright © 2020 Peter Larson. All rights reserved.
////
//
//import SwiftUI
//
//extension View {
//    
//    var shadow: some View {
//        return self.shadow(color: Color.black.opacity(0.15), radius: 0, x: 0, y: 10)
//    }
//    
//    func shadowed(_ bool: Bool) -> some View {
//        return bool ? AnyView(self.shadow) : AnyView(self)
//    }
//}
//
//struct PlayerSkinView: View {
//    
//    let skin: PlayerSkin
//    
////    init(skin: String, selected: Binding<Bool>) {
////        self.skin =
////    }
//    
//    @State var texture = "chef.idle.right.1"
//    @Binding var selected: Bool
//    
//    @State private var ghost: Bool = true
//    
//    func updateTexture() {
//        Timer.scheduledTimer(withTimeInterval: 1.0 / 20, repeats: true) { (timer) in
//            
//            if self.ghost {
//                self.ghost = false
//            }
//            
//            self.texture = self.skin.next()
//        }
//    }
//    
//    var player: AnyView {
//        if ghost {
//            return AnyView(Color.black.mask(Image(texture)
//            .resizable()
//            .scaledToFit()))
//        } else {
//            return AnyView(Image(texture)
//                .resizable()
//                .scaledToFit()
//                .shadow(color: Color.yellow, radius: self.selected ? 5:0 , x: 0, y: 0))
//        }
//    }
//    
//    @State var press = false
//    
//    var buttonText: some View {
//        Text(self.selected ? "Selected" : "Select")
//            .font(.custom("Belligan", size: 24))
//            .foregroundColor(.white)
//    }
//    
//    var button: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 32)
//                .foregroundColor(self.selected ? Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)) : Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
//                .shadowed(!self.selected)
//            RoundedRectangle(cornerRadius: 32)
//                .strokeBorder(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), lineWidth: self.selected ? 0:5, antialiased: true)
//            self.buttonText
//        }.modifier(GameButton(isPressed: $press)).animation(.easeInOut(duration: 0.3)).onAppear(perform: updateTexture)
//    }
//    
//    var body: some View {
//        ZStack {
//            Color.white
//            HStack(spacing: 0) {
//                self.player.frame(width: 100)
//                VStack {
//                    Text(self.skin.outfit.rawValue)
//                        .font(.custom("Belligan", size: 32))
//                    Text(self.skin.outfit.description)
//                        .font(.custom("Belligan", size: 16))
//                    self.button
//                }.foregroundColor(.black)
//            }.padding(.vertical, 16).padding(.horizontal, 32)
//        }
//        .frame(height: 200)
//        .foregroundColor(.white)
//        .cornerRadius(32)
//        .shadow(color: Color.black.opacity(0.15), radius: 0, x: 0, y: 10)
//    }
//}
//
//struct PlayerSkinView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            Color.black.opacity(0.15).edgesIgnoringSafeArea(.all)
////            VStack {
////                PlayerSkinView(skin: "chef", selected: .constant(true))
////                    .frame(height: 200)
////                PlayerSkinView(skin: "chef", selected: .constant(false))
////                    .frame(height: 200)
////                PlayerSkinView(skin: "chef", selected: .constant(true))
////                    .frame(height: 200)
////            }
////            .padding(.horizontal, 32)
//        }
//    }
//}
