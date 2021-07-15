//
//  DateFilter.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/11.
//

import Foundation

struct DateFilter: FilterProtocol {
    let range_: DateInterval
    
    init(start: Date, end: Date) {
        range_ = DateInterval(start: start, end: end)
    }
    
    func filter(_ record: AccountRecord) -> AccountRecord? {
        return self.range_.contains(record.date) ? record : nil
    }
    
}
