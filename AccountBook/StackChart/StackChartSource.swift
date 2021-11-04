//
//  StackChartSource.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/08/08.
//

import Foundation
import AppKit

struct ColorMap {
    private var cnt_: Int = 0
    private let colorMap_: [NSColor]
    
    mutating func getColor() -> NSColor {
        self.cnt_ += 1
        return self.colorMap_[(self.cnt_ - 1) % self.colorMap_.count]
    }
    
    static var green: Self {
        .init( colorMap_: [#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)] )
    }
    static var blue: Self {
        .init( colorMap_: [#colorLiteral(red: 0.6898882689, green: 0.8566111673, blue: 1, alpha: 1), #colorLiteral(red: 0.5266725783, green: 0.7811438276, blue: 1, alpha: 1), #colorLiteral(red: 0.3058738458, green: 0.6790513579, blue: 1, alpha: 1), #colorLiteral(red: 0.1607304846, green: 0.5951248908, blue: 0.9687226836, alpha: 1), #colorLiteral(red: 0.2048474171, green: 0.5174363524, blue: 0.7862762238, alpha: 1), #colorLiteral(red: 0.1835103863, green: 0.388805573, blue: 0.5653682255, alpha: 1)] )
    }
    static var red: Self {
        .init( colorMap_: [#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)] )
    }
}

struct StackChartSource {
    enum Direction {
        case ascending
        case descending
    }
    struct Item<Value>: Identifiable where Value: Numeric {
        let id = UUID()
        let tuple: (String, Value)
        
        let color: CGColor
    }
    
    let items: [String: Double]
    let total: Double
    var colorMap: ColorMap
    
    init(items: [String: Double], colorMap: ColorMap = .blue) {
        self.items = items
        self.total = items.reduce(0) {$0 + $1.value}
        
        self.colorMap = colorMap
    }
    
    func items(sortedBy direction: Direction) -> [Item<Double>] {
        var cMap = self.colorMap
        
        if direction == .ascending {
            return self.items
                .sorted { $0.value < $1.value }
                .map {.init(tuple: $0, color: cMap.getColor().cgColor)}
        } else {
            return self.items
                .sorted { $0.value > $1.value }
                .map {.init(tuple: $0, color: cMap.getColor().cgColor)}
        }
    }
}
