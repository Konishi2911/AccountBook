//
//  CategoryFilter.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/11.
//

import Foundation

struct CategoryFilter: FilterProtocol {
    let category_: AccountCategory
    
    init (category: AccountCategory) {
        self.category_ = category
    }
    
    func filter(_ record: AccountRecord) -> AccountRecord? {
        return record.category.isIncluded(in: self.category_) ? record : nil
    }
}
