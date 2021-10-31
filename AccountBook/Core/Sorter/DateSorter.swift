//
//  DateSorter.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/11.
//

import Foundation

struct DateSotrter: SorterProtocol {
    private let direction_: SortDirection
    
    init(_ direction: SortDirection) {
        self.direction_ = direction
    }
    
    func sort(_ ids: [Int], ref: Database) -> [Int] {
        switch self.direction_ {
        case .ascending:
            return ids.sorted { ref[$0].date < ref[$1].date }
        case .discending:
            return ids.sorted { ref[$0].date > ref[$1].date }
        }
    }
    
        
}
