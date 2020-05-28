//
//  DeveloperView.swift
//  Elevators
//
//  Created by Peter Larson on 5/10/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct DeveloperView: View {
        
    @Binding var isShowing: Bool
    
    @ObservedObject var saves = Storage.current
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Status").font(.title)) {
                    Text("\(self.saves.levels.count) Levels")
                }
                Section(header: Text("Create").font(.title)) {
                    NavigationLink(destination: LevelDesignerView().lazy()) {
                        Text("New")
                    }
                }
                Section(header: HStack {
                    Text("Levels").font(.title)
                }) {
                    List {
                        ForEach(self.saves.levels) { model in
                            NavigationLink(destination: LevelDesignerView(from: model).lazy()) {
                                HStack {
                                    Text("\(model.id). \(model.name)")
                                    Spacer()
                                    if Storage.current.isLocalallySaved(model: model) {
                                        Text("Local")
                                            .foregroundColor(.red)
                                            .underline()
                                    } else {
                                        Text("Hard Saved")
                                            .foregroundColor(.green)
                                            .italic()
                                    }
                                }
                            }.deleteDisabled(!Storage.current.isLocalallySaved(model: model))
                        }
                        .onMove { (indexSet, destination) in
                            self.saves.move(offsets: indexSet, destination: destination)
                        }.onDelete { (indexSet) in
                            Storage.current.remove(indexSet)
                        }
                        .listStyle(GroupedListStyle())
                    }

                    if self.saves.levels.isEmpty {
                        Text("There are no Levels to load from.")
                            .foregroundColor(.gray)
                    } else {
                        NavigationLink(destination: LevelShareView()) {
                            Text("Share")
                        }
                    }
                }
                
                Button("Done") {
                    self.isShowing = false
                }

            }
            .navigationBarTitle("Menu", displayMode: .large)
            .navigationBarItems(trailing: EditButton())
            .font(.custom("Futura Medium", size: 16))

        }
    }
}

struct DeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperView(isShowing: .constant(true))
    }
}

extension String: Identifiable {
    public var id: String {
        self
    }
}
