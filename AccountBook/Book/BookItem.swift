//
//  BookItem.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/09/20.
//

import Foundation

struct BookItem: Identifiable {
    let id: UUID
    
    let date: Date
    let category: AccountCategory
    let name: String
    let amounts: UInt
    let remarks: String
    
    init(from record: AccountRecord) {
        self.id = record.id
        
        self.date = record.date
        self.category = record.category
        self.name = record.name
        self.amounts = record.amounts
        self.remarks = record.remarks
    }
}
