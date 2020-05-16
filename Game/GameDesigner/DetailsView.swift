//
//  DetailsView.swift
//  Elevators
//
//  Created by Peter Larson on 4/29/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct DetailsView: View {
    
    @Binding var name: String
    @Binding var floors: Int
    @Binding var slots: Int
    @Binding var elevators: [ElevatorModel]
    @Binding var coins: [CoinModel]
    @Binding var start: CellModel?
    @Binding var id: Int
    
    @Binding var isDetailing: Bool
        
    var body: some View {
        Form {
            Section(header: Text("Settings").font(.title)) {
                TextField("Name", text: $name)
                    .textFieldStyle(PlainTextFieldStyle())
                Stepper("\(floors) Floors", value: $floors)
                Stepper("\(slots) Slots", value: $slots)
            }
            
            Section(header: Text("Data").font(.title)) {
                Text("Elevators: \(elevators.count)")
                Text("Coins: \(coins.count)")
                Text("Starting Position: \(start?.description ?? "none")")
            }
            
            Section(header: Text("Save").font(.title)) {
                if LevelStorage.current.contains(name) {
                    Text("Warning! Saving will overwrite a previous save!")
                        .italic()
                        .foregroundColor(.red)
                }
                if floors < 1 {
                    Text("Not enough floors!")
                        .foregroundColor(.red)
                }
                else if slots < 1 {
                    Text("Not enough slots!")
                        .foregroundColor(.red)
                }
                else if name.isEmpty {
                    Text("Name is empty!")
                        .foregroundColor(.red)
                }
                else {
                    Button("Save as \"\(name)\".") {
                        LevelStorage.current.save(
                            LevelModel(
                                name: self.name,
                                floors: self.floors,
                                slots: self.slots,
                                elevators: self.elevators,
                                coins: self.coins,
                                start: self.start,
                                id: self.id
                            )
                        )
                        
                        self.isDetailing.toggle()
                    }
                }
            }
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(
            name: .constant(String()),
            floors: .constant(10),
            slots: .constant(5),
            elevators: .constant([]),
            coins: .constant([]),
            start: .constant(nil),
            id: .constant(0),
            isDetailing: .constant(false)
        )
    }
}
