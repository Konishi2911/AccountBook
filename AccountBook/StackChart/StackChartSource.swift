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
        .init( colorMap_: [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)] )
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
