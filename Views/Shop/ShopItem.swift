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
        
        ZStack {
            Color("shop-tile")
                .shadow(radius: 5)
                .cornerRadius(16)
            VStack {
                Text("200 Elevator Bucks")
                Image("cash")
                    .resizable()
                    .scaledToFit()
                HStack {
                    Text("$1")
                    Spacer()
                    GameButton {
                        Text("Buy")
                            .foregroundColor(.white)
                    }
                    .foregroundColor(Color("theme-1"))
                }
            }
            .padding()
        }
        .foregroundColor(.white)
        .font(.custom("Chalkboard SE Bold", size: 24))
    }
}

// TODO: Actually do something.
public extension ShopItem {
    func fullfill() {
        switch type {
        case .ad:
            return
        case .coin:
            GameData.cash += count ?? 0
            
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
