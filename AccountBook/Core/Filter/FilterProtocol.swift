//
//  FilterProtocol.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/11.
//

import Foundation

protocol FilterProtocol {
    associatedtype RecordType = AccountDatabase.RecordType
    associatedtype IndexType = Int
        
    func filter(_ record: RecordType) -> RecordType?
}
