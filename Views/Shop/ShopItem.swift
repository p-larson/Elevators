//
//  ShopItem.swift
//  Elevators
//
//  Created by Peter Larson on 5/28/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import Foundation
import SwiftUI

public enum ShopItemType: Int, Codable {
    case coin, ad
}

public struct ShopItem: View, Codable {
    public let price: Double
    public let type: ShopItemType
    public let count: Int?
    public let id: UUID
    
    public var body: some View {
        VStack(spacing: 0) {
            ZStack {
                
                Color.white
                
                if self.type == .ad {
                    Text("Remove\nAll Ads")
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .foregroundColor(Color("shop-text"))
                    
                }
                
                if self.type == .coin && self.count != nil {
                    Image("coin")
                        .resizable()
                        .scaledToFit()
                        .padding()
                    VStack {
                        Spacer()

                        HStack {
                            Text("x\(self.count!.description)")
                                .foregroundColor(Color("shop-text"))
                        }
                    }.padding()
                }
                
            }
            .font(.custom("Futura Bold", size: 32))
            GameButton {
                Text("$\(self.price.description)")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(.white)
            }
            .foregroundColor(Color("Coin"))
            .font(.custom("Futura Bold", size: 24))
        }.buttonCornerRadius(0).doesButtonScale(enabled: false).cornerRadius(16)
    }
}

// TODO: Actually do something.
public extension ShopItem {
    func fullfill() {
        switch type {
        case .ad:
            return
        case .coin:
            
            Storage.current.cash += count ?? 0
            
            return
        }
    }
}

struct ShopItem_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GameBackground()
            VStack {
                ShopItem(price: 0.99, type: .ad, count: 100, id: UUID())
                    .frame(width: 250, height: 250)
                ShopItem(price: 0.99, type: .coin, count: 100, id: UUID())
                    .frame(width: 250, height: 250)
            }
        }
    }
}
