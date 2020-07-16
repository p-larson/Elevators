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
import Haptica

struct ShopView: View {
    
    @ObservedObject var storage = GameData
    
    @Binding var isShowing: Bool
    @State var selection = 0
    @State var page = 0
    @State var showCredits = false
    @State var showRandomUnlock = false
    @State var outfit: PlayerOutfit? = nil
    
    init(isShowing: Binding<Bool>) {
        self._isShowing = isShowing
        
        // Set the selection to the index of the current outfit.
        
        coinUnlockables.enumerated().forEach { (index, outfit) in
            if outfit == self.storage.outfit {
                self._selection = State(initialValue: index)
            }
        }
        
        adUnlockables.enumerated().forEach { (index, outfit) in
            if outfit == self.storage.outfit {
                self._selection = State(initialValue: index + (index % gridRange.count) * gridRange.count)
            }
        }
    }
    
    let coinUnlockables = [
        PlayerOutfit.orange,
        PlayerOutfit.goose,
        PlayerOutfit.strawberry,
        PlayerOutfit.firefighter,
        PlayerOutfit.spaceman,
        PlayerOutfit.spaceman2,
        PlayerOutfit.spacewoman,
        PlayerOutfit.camperlady,
        PlayerOutfit.pinneapple
    ]
    
    var coinPages: Range<Int> {
        return 0 ..< max(1, Int((Double(coinUnlockables.count) / Double(gridRange.count)).rounded(.up)))
    }
    
    let adUnlockables = [
        PlayerOutfit.scuba,
        PlayerOutfit.banana,
        PlayerOutfit.chef,
        PlayerOutfit.mailman,
        PlayerOutfit.pilot
    ]
    
    var adPages: Range<Int> {
        return coinPages.upperBound ..< coinPages.upperBound + max(1, Int((Double(adUnlockables.count) / Double(gridRange.count)).rounded(.up)))
    }
    
    let purchasables: [ShopItem] = [
        ShopItem(price: 0.99, type: .coin, count: 100, id: UUID()),
        ShopItem(price: 4.99, type: .coin, count: 1_000, id: UUID()),
        ShopItem(price: 9.99, type: .coin, count: 3_000, id: UUID()),
        ShopItem(price: 0.99, type: .ad, count: nil, id: UUID())
    ]
    
    var pages: ClosedRange<Int> {
        coinPages.lowerBound ... adPages.upperBound
    }
    
    func showSelector(on page: Int) -> Bool {
        return (selection / (gridLength * gridLength)) == page
    }
    
    let gridLength = 3
    
    var gridRange: Range<Int> {
        0 ..< gridLength * gridLength
    }
    
    typealias PrefernceTransformer = (GridItemBoundsPreferencesKey.Value) -> AnyView
    
    func selection(on page: Int) -> PrefernceTransformer {
        return { (value) in
            AnyView(
                ZStack {
                    if self.showSelector(on: page) {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(lineWidth: 4)
                            .foregroundColor(.white)
                            .frame(
                                width: value[self.selection % (self.gridLength * self.gridLength)].width,
                                height: value[self.selection % (self.gridLength * self.gridLength)].height
                        )
                            .position(
                                x: value[self.selection % (self.gridLength * self.gridLength)].midX,
                                y: value[self.selection % (self.gridLength * self.gridLength)].midY
                        )
                    } else {
                        EmptyView()
                    }
                }
                .animation(nil)
            )
        }
    }
    
    func item(on page: Int, index: Int) -> some View {
        var outfit: PlayerOutfit? = nil
        
        // let pagedIndex = page * gridRange.count + index
        
        if coinPages.contains(page) {
            outfit = coinUnlockables.safe(index: index)
        } else if adPages.contains(page) {
            outfit = adUnlockables.safe(index: index)
        }
        
        return PlayerOutfitView(outfit: outfit)
            .onTapGesture {
                if let outfit = outfit, outfit.isUnlocked {
                    self.storage.outfit = outfit
                    self.selection = index + page * self.gridRange.count
                    Haptic.impact(.light).generate()
                } else {
                    Haptic.notification(.warning).generate()
                }
        }
    }
    
    func content(page: Int) -> some View {
        if coinPages.contains(page) || adPages.contains(page) {
            return AnyView(
                Grid(gridRange) { index in
                    return self.item(on: page, index: index)
                }
                .overlayPreferenceValue(GridItemBoundsPreferencesKey.self) { value in
                    AnyView(
                        ZStack {
                            if self.showSelector(on: self.page) {
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(lineWidth: 4)
                                    .foregroundColor(.white)
                                    .frame(
                                        width: value[self.selection % (self.gridLength * self.gridLength)].width,
                                        height: value[self.selection % (self.gridLength * self.gridLength)].height
                                )
                                    .position(
                                        x: value[self.selection % (self.gridLength * self.gridLength)].midX,
                                        y: value[self.selection % (self.gridLength * self.gridLength)].midY
                                )
                            } else {
                                EmptyView()
                            }
                        }
                        .animation(nil)
                    )
                }
            )
        }
        
        return AnyView(
            Grid(0 ..< 4) { index in
                if self.purchasables.indices.contains(index) {
                    self.purchasables[index]
                } else {
                    EmptyView()
                }
            }
            .gridStyle(ModularGridStyle(columns: 2, rows: 2, spacing: 8))
        )
    }
    
    var length: CGFloat {
        min(UIScreen.main.bounds.width, UIScreen.main.bounds.height / 2) - 32
    }
    
    var randomUnlockView: some View {
        ZStack {
            if showRandomUnlock {
                UnlockElevatorView(outfit: outfit!, isShowing: $showRandomUnlock)
            }
        }
    }
    
    var creditsView: some View {
        ZStack {
            if showCredits {
                CreditsView(isShowing: $showCredits)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color("shop")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 8) {
                Spacer()
                VStack(spacing: 0) {
                    PlayerOutfitView()
                        .frame(
                            width: UIScreen.main.bounds.width / 3,
                            height: UIScreen.main.bounds.width / 3
                    )
                    HStack {
                        Text("\(self.storage.outfit.name)")
                        Text("\(self.selection)/128 Collected")
                            .brightness(-0.5)
                    }
                    .padding(.horizontal, 32)
                    .foregroundColor(.white)
                    .font(.custom("Futura   Medium", size: 16))
                }
                
                Pager(page: $page, data: Array(pages), id: \.self) { index in
                    self.content(page: index)
                    
                }
                .itemAspectRatio(1.0, alignment: .center)
                .itemSpacing(16)
                .padding(16)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                
                HStack {
                    ForEach(pages, id: \.self) { page in
                        Circle()
                            .foregroundColor(page == self.page ? .white : .gray)
                            .frame(width: 8, height: 8)
                            .scaleEffect(page == self.page ? 1 : 0.8)
                            .animation(.easeInOut(duration: 0.3), value: self.page)
                    }
                }
                .padding(.top, -16)
                
                Spacer()
                
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
                        .foregroundColor(.white)
                        .frame(height: 32)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.custom("Futura Bold", size: 16))
                    }
                    .padding(.horizontal, 16)
                    .onButtonPress {
                        let locked = self.coinUnlockables.filter { (outfit) -> Bool in
                            !outfit.isUnlocked
                        }

                        if let outfit = locked.randomElement() {
                            self.outfit = outfit
                            self.showRandomUnlock = true
                        }
                    }
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
                } else {
                    GameButton {
                        Text("Free Coins")
                            .foregroundColor(.white)
                            .frame(height: 32)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .font(.custom("Futura Bold", size: 16))
                    }
                    .padding(.horizontal, 16)
                    .foregroundColor(.red)
                    .onButtonPress {
                        self.showCredits = true
                    }
                }
                GameButton {
                    Text("Done")
                         .frame(height: 32)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.white)
                        .font(.custom("Futura Bold", size: 16))
                }
                .padding(.horizontal, 16)
                .onButtonPress {
                    self.isShowing = false
                }
            }
            .buttonHighlightsPadding(5)
            .buttonHighlights(true)
            .gridStyle(ModularGridStyle(columns: 3, rows: 3, spacing: 8))
            .font(.custom("Futura Bold", size: 32))
            .foregroundColor(Color("theme-1"))
            
            self.randomUnlockView
                .zIndex(2)
            
            self.creditsView
        }
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView(isShowing: .constant(true))
            .statusBar(hidden: true)
            .previewDevice("iPhone 11")
    }
}

extension Array {
    func safe(index: Int) -> Element? {
        if !indices.contains(index) {
            return nil
        }
        return self[index]
    }
}
