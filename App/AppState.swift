//
//  AppState.swift
//  Elevators
//
//  Created by Peter Larson on 7/1/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

public class AppState: ObservableObject {
    @Published var showOverhead = false
    @Published var showShop = false
    @Published var showDailyPrize = false
}

