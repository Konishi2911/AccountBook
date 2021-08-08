//
//  StackChartSource.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/08/08.
//

import Foundation

struct StackChartSource {
    enum Direction {
        case ascending
        case descending
    }
    struct Item<Value>: Identifiable where Value: Numeric {
        let id = UUID()
        let tuple: (String, Value)
    }
    
    let items: [String: Double]
    let total: Double
    
    init(items: [String: Double]) {
        self.items = items
        self.total = items.reduce(0) {$0 + $1.value}
    }
    
    func items(sortedBy direction: Direction) -> [Item<Double>] {
        if direction == .ascending {
            return self.items
                .sorted { $0.value < $1.value }
                .map {.init(tuple: $0)}
        } else {
            return self.items
                .sorted { $0.value > $1.value }
                .map {.init(tuple: $0)}
        }
    }
}
