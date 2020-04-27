////
////  HomeView.swift
////  Elevators
////
////  Created by Peter Larson on 4/6/20.
////  Copyright © 2020 Peter Larson. All rights reserved.
////
//
//import SwiftUI
//
//let size = CGSize(width: 90 * 1.3, height: 150 * 1.3)
//
//struct HomeView: View {
//    
//    @State var play: Bool = false
//    @State var isShowingSettings: Bool = false
//    
//    var body: some View {
//        ZStack {
//            GeometryReader { proxy in
//                RadialGradient(
//                    gradient: Gradient(colors: [Color(red: 0, green: 187/255, blue: 1), Color(red: 0, green: 173/255, blue: 235/255)]), center: .center, startRadius: 0, endRadius: proxy.size.width / 2)
//            }.edgesIgnoringSafeArea(.all)
//            
//            VStack(spacing: 20) {
//                HStack {
//                    CoinCounter()
//                        .frame(width: 90, height: 40)
//                    Spacer()
//                    SettingsButton()
//                        .frame(width: 30, height: 30)
//                        .foregroundColor(Color(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)))
//                        .modifier(GameButton(isPressed: $isShowingSettings))
//                }.padding(.horizontal, 24)
//                Spacer()
//                ZStack {
//                    Rectangle()
//                        .frame(height: 30)
//                        .foregroundColor(.black)
//                        .shadow(color: Color.black.opacity(0.15), radius: 0, x: 0, y: 10)
//                        .offset(y: 150 / 2 * 1.3 + 15)
//                    Image(
//                        uiImage: Graphics.elevatorBackground(size: size, style: .demo)
//                    )
//                    Image(
//                        uiImage: Graphics.elevatorOverlay(size: size, style: .demo, percent: 1)
//                    )
//                    PlayerView()
//                        .frame(width: 75, height: 130)
//                        .offset(x: -20, y: 40)
//                    WardrobeButton()
//                        .frame(width: 50, height: 50)
//                        .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
//                        .modifier(GameButton(isPressed: .constant(false)))
//                        .offset(x: size.width / 2 + 8 + 25)
//                    GameTitle("Elevators")
//                        .scaleEffect(1.2)
//                        .offset(y: -175)
//                }.frame(height: 250).background(Rectangle().frame(width: 10, height: 1000).offset(y: -500).foregroundColor(.gray))
//                
//                
//                GameTitleButton("Play", pressed: self.$play)
//                    .frame(width: 250, height: 50)
//                    .foregroundColor(Color(#colorLiteral(red: 0.3155179322, green: 0.9531643987, blue: 0.08738277107, alpha: 1)))
//                    .padding(.bottom, 200)
//                    .padding(.top, 20)
//            }
//            .disabled(isShowingSettings)
//            .blur(radius: isShowingSettings ? 2.5:0)
//            .animation(.easeInOut(duration: 0.3))
//            .foregroundColor(.white)
//            .zIndex(0)
//            Color.black.opacity(isShowingSettings ? 0.15 : 0).edgesIgnoringSafeArea(.all)
//                .animation(.easeInOut(duration: 0.3))
//            SettingsView(open: $isShowingSettings)
//                .offset(x: 0, y: self.isShowingSettings ? 0 : 200)
//                .opacity(self.isShowingSettings ? 1 : 0)
//                .animation(.easeInOut(duration: 0.3))
//                .zIndex(1)
//        }
//        
//    }
//}
//
//struct HomeViewPreviews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
