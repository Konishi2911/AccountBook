//
//  AccountDatabase.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/11.
//

import Foundation

class AccountDatabase {
    typealias RecordType = AccountRecord
    
    private var table_: [RecordType]
    
    public init() {
        table_ = []
    }
    /*
    public init(_ url: URL) throws {
        //let data = try Data(contentsOf: url)
    }
 */
    
    public var numberOfRecords: Int { self.table_.count }
    
    
    // MARK: Operating Database

    public func add(_ record: RecordType) {
        table_.append(record)
    }
    
    public func remove(_ recordNo: Int) {
        table_.remove(at: recordNo)
    }
    
    public func replace(_ record: RecordType, to newRecord: RecordType) {
        
    }
    
    
    // MARK: Record Getter
    
    public subscript(position: Int) -> RecordType {
        get {
            return self.table_[position]
        }
    }
    
    public func getRecords() -> RecordCollection {
        RecordCollection(self)
    }
}
