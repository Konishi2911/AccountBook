//
//  AggregatorProtocol.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/26.
//

import Foundation

protocol AggregatorProtocol {
    associatedtype LabelType: Hashable
    associatedtype ValueType: FloatingPoint
    
    func aggregate(ref: RecordCollection) -> AggregatedItems<LabelType>
}

@available(*, deprecated)
struct AggregateStrategy<T> where T: FloatingPoint {
    private let method: ([T]) -> T
    
    init(method: @escaping ([T]) -> T) {
        self.method = method
    }
    
    func calc(contents: [T]) -> T {
        self.method(contents)
    }
    
    
    static var sum: Self {
        .init {
            var tmp: T = .zero
            for val in $0 { tmp += val }
            return tmp
        }
    }
    
    static var average: Self {
        .init {
            var tmp: T = .zero
            for val in $0 { tmp += val }
            return tmp / T($0.count)
        }
    }
}

struct AggregatedItems<L> where L: Hashable {
    let records: [L : [AccountRecord]]
    var count: Int { self.records.count }
    
    func summed<T>(content: (AccountRecord) -> T ) -> [L: T] where T: Numeric {
        var itemDict: [L: T] = [:]
        for pair in self.records {
            var sum: T = .zero
            for rec in pair.value {
                sum += content(rec)
            }
            itemDict[pair.key] = sum
        }
        return itemDict
    }
    
    func averaged<T>(content: (AccountRecord) -> T ) -> [L: T] where T: FloatingPoint {
        var itemDict: [L: T] = [:]
        for pair in self.records {
            var sum: T = .zero
            for rec in pair.value {
                sum += content(rec)
            }
            itemDict[pair.key] = sum / (pair.value.count != 0 ? T(pair.value.count) : 1)
        }
        return itemDict
    }
}

