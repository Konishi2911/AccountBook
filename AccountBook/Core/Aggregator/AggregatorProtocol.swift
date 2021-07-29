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
    
    func aggregate(
        strategy: AggregateStrategy<ValueType>,
        type: AccountCategoryProvider.AccountType,
        content: (AccountRecord) -> ValueType
    ) -> [LabelType: ValueType]
}

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

