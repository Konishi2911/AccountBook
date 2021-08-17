//
//  AccountDatabase.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/11.
//

import Foundation

class AccountDatabase {
    typealias RecordType = AccountRecord
    
    private var sourceURL: URL? = nil
    private var table_: [RecordType]
    
    public init() {
        table_ = []
    }
    
    public init(from url: URL) throws {
        let ioProxy = try IOTableProxy(url: url)
        self.table_ = ioProxy.getTable()
        self.sourceURL = url
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
    
    
    public var numberOfRecords: Int { self.table_.count }
    
    public func setURL(url: URL) {
        self.sourceURL = url
    }
    
    internal func save() {
        let proxy = IOTableProxy(base: self.table_)
        
        if let url = self.sourceURL {
            print("Saved to \(url)")
            try! proxy.save(to: url)
        }
    }
    
    
    // MARK: Operating Database

    public func add(_ record: RecordType) {
        table_.append(record)
        
        self.save()
    }
    
    public func remove(_ recordNo: Int) {
        table_.remove(at: recordNo)
        
        self.save()
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
                date: cal.date(from: DateComponents(year: 2020, month: 10, day: 23))!,
                category: AccountCategory(type: .income, nameSequence: ["Salary"])!,
                name: "",
                pcs: 1,
                amounts: 5000,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2020, month: 12, day: 23))!,
                category: AccountCategory(type: .outlay, nameSequence: ["Food", "Groceries"])!,
                name: "Coockie",
                pcs: 1,
                amounts: 240,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 1, day: 23))!,
                category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
                name: "",
                pcs: 1,
                amounts: 5015,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 3, day: 13))!,
                category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
                name: "",
                pcs: 1,
                amounts: 9123,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 5, day: 29))!,
                category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
                name: "",
                pcs: 1,
                amounts: 300,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 5, day: 3))!,
                category: AccountCategory(type: .outlay, nameSequence:
                                            ["Entertainments", "Hobby"]
                )!,
                name: "",
                pcs: 1,
                amounts: 2123,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 6, day: 3))!,
                category: AccountCategory(type: .income, nameSequence: ["Salary"])!,
                name: "",
                pcs: 1,
                amounts: 2123,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 8, day: 1))!,
                category: AccountCategory(type: .outlay, nameSequence:
                                            ["Food", "Groceries"]
                )!,
                name: "",
                pcs: 1,
                amounts: 2123,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 8, day: 1))!,
                category: AccountCategory(type: .outlay, nameSequence:
                                            ["Food", "Eating Out"]
                )!,
                name: "",
                pcs: 1,
                amounts: 2123,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 8, day: 1))!,
                category: AccountCategory(type: .outlay, nameSequence:
                                            ["Food", "Groceries"]
                )!,
                name: "",
                pcs: 1,
                amounts: 2123,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 8, day: 1))!,
                category: AccountCategory(type: .outlay, nameSequence:
                                            ["Utilities", "Gas"]
                )!,
                name: "",
                pcs: 1,
                amounts: 2123,
                remarks: "None"
            ),
        ]
        
        let db = AccountDatabase()
        for rec in recArray {
            db.add(rec)
        }
        return db
    }
}
