//
//  NameFilter.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/09/25.
//

import Foundation

struct NameFilter: FilterProtocol {
    let string: String
    
    func filter(_ record: AccountRecord) -> AccountRecord? {
        if record.name.contains(self.string) { return record }
        else { return nil }
    }
}
