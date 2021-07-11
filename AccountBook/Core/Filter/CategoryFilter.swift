//
//  CategoryFilter.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/11.
//

import Foundation

struct CategoryFilter: FilterProtocol {
    let cat_: AccountCategory
    
    init (category: AccountCategory) {
        self.cat_ = category
    }
    
    func filter(_ record: AccountRecord) -> AccountRecord? {
        return self.cat_ == record.category ? record : nil
    }
}
