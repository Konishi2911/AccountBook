//
//  RecordCollectionProtocol.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/08/06.
//

import Foundation

protocol RecordCollectionProtocol: Collection
    where SubSequence: RecordCollectionProtocol,
          Element == AccountRecord,
          Index == Int {
    func getArray() -> [AccountRecord]
    
    func filtered<T>(by filter: T) -> Self
    where T: FilterProtocol, T.RecordType == Self.Element, T.IndexType == Self.Index
    
    func sorted<T>(by sorter: T) -> Self
    where T: SorterProtocol, T.RecordType == Self.Element, T.IndexType == Self.Index
    
}
