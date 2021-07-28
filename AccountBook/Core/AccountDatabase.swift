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
    
    public init(fromBMT url: URL) throws {
        if url.pathExtension != ".bmt" {
            
        }
        
        let decoder = JSONDecoder()
        let data = try Data(contentsOf: url)
        let bmtRecords = try decoder.decode([BMTRecord].self, from: data)
        
        self.table_ = .init()
        for bmtRec in bmtRecords {
            if let rec = bmtRec.toRecord() {
                self.table_.append(rec)
            }
        }
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


extension AccountDatabase {
    static func mock() -> AccountDatabase {
        let cal = Calendar.current
        
        let recArray = [
            AccountRecord(
                date: Date(),
                category: AccountCategory(type: .income, nameSequence: ["Salary"])!,
                name: "",
                pcs: 1,
                amounts: 5000,
                remarks: "None"
            ),
            AccountRecord(
                date: Date(),
                category: AccountCategory(type: .outlay, nameSequence: ["Food", "Groceries"])!,
                name: "Coockie",
                pcs: 1,
                amounts: 240,
                remarks: "None"
            ),
            AccountRecord(
                date: Date(),
                category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
                name: "",
                pcs: 1,
                amounts: 5015,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(byAdding: .month, value: -1, to: Date())!,
                category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
                name: "",
                pcs: 1,
                amounts: 9123,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(byAdding: .month, value: -1, to: Date())!,
                category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
                name: "",
                pcs: 1,
                amounts: 300,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(byAdding: .month, value: -2, to: Date())!,
                category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
                name: "",
                pcs: 1,
                amounts: 2123,
                remarks: "None"
            )
        ]
        
        let db = AccountDatabase()
        for rec in recArray {
            db.add(rec)
        }
        return db
    }
}
