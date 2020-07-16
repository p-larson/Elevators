//
//  GameSettingsView.swift
//  Elevators
//
//  Created by Peter Larson on 6/15/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI
import SpriteKit

struct GameSettingsModel: Codable {
    var maxFloorsShown: CGFloat = 8
    var floorSpeed: TimeInterval = 0.2
    var playerSpeed: TimeInterval = 0.2
    var doorSpeed: TimeInterval = 0.15
    var waveSpeed: TimeInterval = 2.0
    var cameraSpeed: TimeInterval = 0.15
    var padding: CGFloat = 16.0
}

struct GameSettingsView: View {
    
    @State var model: GameSettingsModel = GameData.settings
    
    var body: some View {
        VStack {
            Stepper("\(model.maxFloorsShown.description) Max Floors Shown", value: $model.maxFloorsShown, step: 0.25)
            Stepper("\(model.floorSpeed.description) Floor Speed", value: $model.floorSpeed, step: 0.01)
            Stepper("\(model.playerSpeed.description) Player Speed", value: $model.playerSpeed, step: 0.01)
            Stepper("\(model.doorSpeed.description) Door Speed", value: $model.doorSpeed, step: 0.01)
            Stepper("\(model.waveSpeed.description) Wave Speed", value: $model.waveSpeed, step: 0.01)
            Stepper("\(model.cameraSpeed.description) Camera Speed", value: $model.cameraSpeed, step: 0.01)
            Stepper("\(model.padding.description) Padding", value: $model.padding, step: 1)
            Button("Save") {
                GameData.settings = self.model
            }
        }.padding(.horizontal, 16)
    }
}

struct GameSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GameSettingsView()
    }
}
