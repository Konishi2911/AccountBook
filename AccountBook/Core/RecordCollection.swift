//
//  RecordCollection.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/11.
//

import Foundation

struct RecordCollection: RecordCollectionProtocol {
    typealias SubSequence = Self
    typealias Element = AccountRecord
    typealias Index = Int
    
    private let ref_: AccountDatabase
    
    private let indexMap_: [Index]
    
    public let startIndex: Index
    public let endIndex: Index
    
    
    // MARK: - Initializer
    
    public init (_ ref: AccountDatabase) {
        self.ref_ = ref
        self.indexMap_ = [Index](0..<ref.numberOfRecords)
        
        self.startIndex = 0
        self.endIndex = ref.numberOfRecords
    }
    
    public init (_ ref: AccountDatabase, map: [Index]) {
        self.ref_ = ref
        self.indexMap_ = map
        
        self.startIndex = 0
        self.endIndex = map.count
    }
    
    private init (slicedFrom base: Self, bound: Range<Index>) {
        self.ref_ = base.ref_
        self.indexMap_ = base.indexMap_
        
        self.startIndex = bound.startIndex
        self.endIndex = bound.endIndex
    }
    
    
    public subscript(position: Int) -> AccountRecord {
        get {
            return ref_[indexMap_[position]]
        }
    }
    public subscript(bounds: Range<Int>) -> SubSequence {
        return .init(slicedFrom: self, bound: bounds)
    }
    
    public func index(after i: Int) -> Int { i + 1 }
    
    
    // MARK: - Accessing Records
    
    @available(*, deprecated)
    public func getArray() -> [AccountRecord] {
        var arr: [AccountRecord] = []
        for index in self.indexMap_ {
            arr.append(ref_[index])
        }
        return arr
    }
    
    public func getRecords() -> [(Int, AccountRecord)] {
        var arr: [(Int, AccountRecord)] = []
        for index in self.indexMap_ {
            arr.append((index, ref_[index]))
        }
        return arr
    }
    
    public func filtered<T>(by filter: T) -> Self
    where T: FilterProtocol,
          T.RecordType == Self.Element,
          T.IndexType == Self.Index
    {
        var idMap: [Index] = []
        for id in self.indexMap_ {
            if filter.filter(self.ref_[id]) != nil {
                idMap.append(id)
            }
        }
        return RecordCollection(self.ref_, map: idMap)
    }
    
    public func sorted<T>(by sorter: T) -> Self
    where T: SorterProtocol,
          T.RecordType == Self.Element,
          T.IndexType == Self.Index
    {
        let idMap = sorter.sort(self.indexMap_, ref: self.ref_)
        return RecordCollection(self.ref_, map: idMap)
    }
    
    // MARK: - Redefinition of Protocol
    
    var count: Int { self.indexMap_.count }
}

