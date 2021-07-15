//
//  HistoryItem.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/15.
//

import Foundation

struct HistoryItem {
    let date: Date
    let category: AccountCategory
    let name: String
    let amounts: UInt
    let remarks: String
    
    init(from record: AccountRecord) {
        self.date = record.date
        self.category = record.category
        self.name = record.name
        self.amounts = record.amounts
        self.remarks = record.remarks
    }
}
