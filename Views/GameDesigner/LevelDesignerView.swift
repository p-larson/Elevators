//
//  LevelDesignerView.swift
//  Elevators
//
//  Created by Peter Larson on 4/29/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import SwiftUI

struct LevelDesignerView: View {
    @State var name: String = String()
    @State var floors: Int = 10
    @State var slots: Int = 5
    @State var elevators = [ElevatorModel]()
    @State var coins = [CoinModel]()
    @State var start: CellModel? = nil
    @State var selected: CellModel? = nil
    @State var id: Int
    
    @State var isDetailing = false
    @State var isDemoing = false
    
    let feedback = UIImpactFeedbackGenerator(style: .medium)
    
    init(from model: LevelModel? = nil) {
        guard let model = model else {
            self._id = State(initialValue: GameData.levels.count)
            return
        }
        // Override
        self._id = State(initialValue: model.id)
        self._name = State(initialValue: model.name)
        self._floors = State(initialValue: model.floors)
        self._slots = State(initialValue: model.slots)
        self._elevators = State(initialValue: model.elevators)
        self._coins = State(initialValue: model.coins)
        self._start = State(initialValue: model.start)
    }
    
    var model: LevelModel {
        LevelModel(
            name: name,
            floors: floors,
            slots: slots,
            elevators: elevators,
            coins: coins,
            start: start,
            id: id
        )
    }
    
    var game: some View {
        GameView(
            level: model
        ).edgesIgnoringSafeArea(.all).onAppear {
            print("LevelView has been added to view hierarchy.")
        }
    }
    
    var details: some View {
        NavigationLink(
            destination: DetailsView(
                name: $name,
                floors: $floors,
                slots: $slots,
                elevators: $elevators,
                coins: $coins,
                start: $start,
                id: $id,
                isDetailing: $isDetailing
            ),
            isActive: $isDetailing
        ) {
            Text("Details")
        }
    }
    
    var demoButton: some View {
        NavigationLink(destination: game) {
            Circle()
            .frame(width: 50, height: 50)
            .foregroundColor(.white)
                .shadow(radius: 2.0)
                .overlay(Text("Demo").font(.system(size: 10, weight: .light, design: .monospaced)).foregroundColor(.black))
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                GeometryReader { _ in
                    ForEach(self.getEmpties()) { cell in
                        self.empty(cell: cell, proxy)
                            .zIndex(0)
                    }
                    ForEach(self.getConnectors()) { cell in
                        self.connector(for: cell, proxy)
                            .zIndex(1)
                    }
                    ForEach(self.coins) { coin in
                        self.coin(for: coin, proxy)
                            .zIndex(2)
                    }
                    ForEach(self.elevators) { elevator in
                        self.elevator(for: elevator, proxy)
                            .zIndex(3)
                    }
                }.frame(width: proxy.size.width, height: self.height(proxy) * CGFloat(self.floors))
                self.demoButton
                Color.clear
                    .frame(height: 100)
            }
        }
        .padding()
        .navigationBarItems(trailing: details)
        .navigationBarTitle(
            "Designer",
            displayMode: .inline
        ).edgesIgnoringSafeArea(.bottom)
    }
}

extension LevelDesignerView {
    func getConnectors() -> [CellModel] {
        elevators.map { (model) -> CellModel in
            CellModel(slot: model.slot, floor: model.target)
        }
    }
    
    func getEmpties() ->  [CellModel] {
        var all = [CellModel]()
        
        for slot in 0 ..< slots {
            for floor in 1 ... floors {
                all.append(CellModel(slot: slot, floor: floor))
            }
        }
        
        for model in elevators {
            all.removeAll { cell -> Bool in
                return model.floor != model.target && cell.slot == model.slot && (cell.floor == model.floor || cell.floor == model.target)
            }
        }
        
        return all
    }
}

extension LevelDesignerView {
    func remove(_ model: ElevatorModel) {
        self.elevators.removeAll { (elevator) -> Bool in
            print(elevator, model, elevator == model)
            return elevator == model
        }
    }
    
    func add(_ model: ElevatorModel) {
        self.elevators.append(model)
    }
    
    func replace(with model: ElevatorModel) {
        remove(model)
        add(model)
    }
    
    func remove(_ model: CoinModel) {
        self.coins.removeAll { (coin) -> Bool in
            coin == model
        }
    }
    
    func add(_ model: CoinModel) {
        self.coins.append(model)
    }
    
    func replace(_ model: CoinModel) {
        remove(model)
        add(model)
    }
    
    func coin(at cell: CellModel) -> CoinModel? {
        coins.first { (model) -> Bool in
            model.floor == cell.floor && model.slot == cell.slot
        }
    }
}

extension LevelDesignerView {
    func x(for slot: Int, _ proxy: GeometryProxy) -> CGFloat {
        return (width(proxy) / 2) + (width(proxy) * CGFloat(slot))
    }
    
    func y(for floor: Int, _ proxy: GeometryProxy) -> CGFloat {
        return (height(proxy) * CGFloat(self.floors)) - height(proxy) * (CGFloat(floor) - 0.5)
    }
    
    func width(_ proxy: GeometryProxy) -> CGFloat {
        return proxy.size.width / CGFloat(slots)
    }
    
    func height(_ proxy: GeometryProxy) -> CGFloat {
        return proxy.size.height / GameScene.maxFloorsShown
    }
    
    func empty(cell: CellModel, _ proxy: GeometryProxy) -> some View {
        Color.white
            .cornerRadius(8)
            .padding(2)
            .shadow(radius: 1.0)
            .frame(
                width: width(proxy),
                height: height(proxy)
        )
            .position(
                x: self.x(for: cell.slot, proxy),
                y: self.y(for: cell.floor, proxy)
        )
            .onTapGesture(count: 2, perform: {
                if let coin = self.coin(at: cell) {
                    self.remove(coin)
                } else {
                    self.add(CoinModel(slot: cell.slot, floor: cell.floor))
                }
            })
            .onTapGesture {
                if let model = self.selected {
                    self.replace(
                        with: ElevatorModel(
                            floor: model.floor,
                            slot: model.slot,
                            target: cell.floor
                        )
                    )
                    self.selected = nil
                } else {
                    let model = ElevatorModel(floor: cell.floor, slot: cell.slot, target: cell.floor)
                    
                    self.elevators.append(
                        model
                    )
                    
                    self.selected = cell
                }
                
                self.feedback.impactOccurred()
        }
    }
    
    func connector(for cell: CellModel, _ proxy: GeometryProxy) -> some View {
        Color.blue
            .cornerRadius(8)
            .padding(2)
            .overlay(
                Text(cell.description)
        )
            .frame(
                width: width(proxy),
                height: height(proxy)
        )
            .position(
                x: self.x(for: cell.slot, proxy),
                y: self.y(for: cell.floor, proxy)
        )
            .onTapGesture(count: 2, perform: {
                if let coin = self.coin(at: cell) {
                    self.remove(coin)
                } else {
                    self.add(CoinModel(slot: cell.slot, floor: cell.floor))
                }
                
                self.feedback.impactOccurred()
            })
    }
    
    func coin(for model: CoinModel, _ proxy: GeometryProxy) -> some View {
        Circle()
            .foregroundColor(Color.yellow)
            .padding(2)
            .frame(width: 25, height: 25)
            .position(
                x: self.x(for: model.slot, proxy),
                y: self.y(for: model.floor, proxy) + 25
        )
            .onTapGesture(count: 2, perform: {
                self.remove(model)
                self.feedback.impactOccurred()
            })
    }
    
    func elevator(for model: ElevatorModel, _ proxy: GeometryProxy) -> some View {
        Color.red
            .blendMode(.hardLight)
            .cornerRadius(8)
            .padding(2)
            .overlay(
                Text(model.description)
        )
            .frame(
                width: width(proxy),
                height: height(proxy)
        )
            .position(
                x: self.x(for: model.slot, proxy),
                y: self.y(for: model.floor, proxy)
        )
            .onTapGesture(count: 2, perform: {
                if let coin = self.coin(at: CellModel(slot: model.slot, floor: model.floor)) {
                    self.remove(coin)
                } else {
                    self.add(CoinModel(slot: model.slot, floor: model.floor))
                }
                self.feedback.impactOccurred()
            })
            .onTapGesture {
                self.remove(model)
                self.feedback.impactOccurred()
        }
    }
}

extension LevelDesignerView {
    func elevator(on floor: Int, at slot: Int) -> ElevatorModel? {
        self.elevators.first { model in
            model.floor == floor && model.slot == slot
        }
    }
}

struct LevelDesignerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LevelDesignerView()
                .previewDevice("iPhone X")
        }
    }
}
