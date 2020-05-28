//
//  ShopView.swift
//  Elevators
//
//  Created by Peter Larson on 5/25/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI
import SwiftUIPager
import Grid

struct ShopView: View {
    
    
    @Binding var isShowing: Bool
    @State var page = 0
    @State var presented = false
    
    let coinUnlockables = (0 ..< 32).map { _ in
        PlayerOutfit.chef
    }
    
    var coinPages: Range<Int> {
        return 0 ..< (Int((Double(coinUnlockables.count) / 16.0).rounded(.up)))
    }
    
    let adUnlockables = (0 ..< 16).map { _ in
        return PlayerOutfit.chef
    }
    
    var adPages: Range<Int> {
        return coinPages.upperBound ..< coinPages.upperBound + Int((Double(adUnlockables.count) / 16.0).rounded(.up))
    }
    
    var pages: ClosedRange<Int> {
        coinPages.lowerBound ... adPages.upperBound
    }
    
    var gridRange: Range<Int> {
        0 ..< 16
    }
    
    var cell: some View {
        ZStack {
            Color("shop-tile")
                .cornerRadius(8)
            Text("?")
                .foregroundColor(Color("shop-text"))
                .scaleEffect(2.0)
        }
    }
    
    func content(page: Int) -> some View {
        if coinPages.contains(page) {
            return AnyView(
                Grid(gridRange) { index in
                    self.cell
                }
            )
        }
        
        if adPages.contains(page) {
            return AnyView(
                Grid(gridRange) { index in
                    self.cell
                }
            )
        }
        
        return AnyView(
            Grid(0 ..< 4) { index in
                ZStack {
                    Color("Coin")
                }.cornerRadius(8)
            }
            .gridStyle(ModularGridStyle(columns: 2, rows: 2, spacing: 8))
        )
    }
    
    var pagerTransition: AnyTransition {
        AnyTransition
            .asymmetric(
                insertion: AnyTransition.opacity.animation(Animation.linear.delay(0.3)),
                removal: .opacity
        )
    }
    
    var body: some View {
        ZStack {
            Color("shop")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                VStack {
                    Image("chef.idle.right.1")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: UIScreen.main.bounds.height / 8,
                            height: UIScreen.main.bounds.height / 8
                    )
                    Text("Chef")
                    Text("1/128 Collected")
                        .brightness(-0.5)
                }.font(.custom("Futura Medium", size: 16))
                
                Group {
                    Pager(page: $page, data: Array(pages), id: \.self) { index in
                        self.content(page: index)
                            .padding(8)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                            .transition(.identity)
                    }
                    .padding()
                    .itemSpacing(16)
                    .alignment(.center)
                    .opacity(self.presented ? 1.0 : 0.0)
                    .animation(.linear, value: self.page)
                    .animation(Animation.linear.delay(0.3), value: self.presented)
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                
                HStack {
                    ForEach(pages, id: \.self) { page in
                        Circle()
                            .foregroundColor(page == self.page ? .white : .gray)
                            .frame(width: 10, height: 10)
                    }
                }
                
                if coinPages.contains(page) {
                    GameButton {
                        HStack {
                            Text("Random Unlock")
                            Image("coin")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                            Text("250")
                        }
                        .foregroundColor(Color("Coin"))
                        .frame(height: 32)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.custom("Futura Bold", size: 16))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                } else if adPages.contains(page) {
                    GameButton {
                        HStack {
                            Text("Ad Unlock")
                            Image("ad")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                        }
                        .foregroundColor(.white)
                        .frame(height: 32)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.custom("Futura Bold", size: 16))
                    }
                    .foregroundColor(Color("ad"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }  else {
                    GameButton {
                        HStack {
                            Text("Free Coins")
                                .frame(height: 32)
                        }
                        .foregroundColor(.white)
                        .frame(height: 32)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.custom("Futura Bold", size: 16))
                    }
                    .foregroundColor(.red)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                Spacer()
                Button("Done") {
                    self.isShowing.toggle()
                }
                .brightness(-0.5)
                .opacity(0.5)
            }
            .gridStyle(ModularGridStyle(columns: 4, rows: 4, spacing: 8))
            .font(.custom("Futura Bold", size: 32))
            .foregroundColor(.white)
            .onAppear {
                withAnimation {
                    self.presented = true
                }
            }
        }
    }
}

struct ShopTestView: View {
    @State var presented = true
    
    var body: some View {
        ZStack {
            Button("Present") {
                withAnimation {
                    self.presented = true
                }
            }
            
            if presented {
                ShopView(isShowing: $presented)
            }
        }
        .transition(.opacity)
        .animation(Animation.linear)
    }
}

struct ShopView6_Previews: PreviewProvider {
    static var previews: some View {
        ShopTestView()
            .statusBar(hidden: true)
    }
}
