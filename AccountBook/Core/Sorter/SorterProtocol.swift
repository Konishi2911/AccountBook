//
//  SorterProtocol.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/11.
//

import Foundation

enum SortDirection {
    case ascending
    case discending
}

protocol SorterProtocol {
    typealias Database = AccountDatabase
    associatedtype RecordType = Database.RecordType
    associatedtype IndexType = Int
    
    init (_ direction: SortDirection)
    func sort(_ ids: [IndexType], ref: Database) -> [IndexType]
}
