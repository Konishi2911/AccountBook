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
        
        NotificationCenter.default.post(name: .AccountDatabaseDidChange, object: nil)
        self.save()
    }
    
    public func remove(_ recordNo: Int) {
        table_.remove(at: recordNo)
        
        NotificationCenter.default.post(name: .AccountDatabaseDidChange, object: nil)
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
    
    
    /// Returns a record that matches given id.
    /// If no records matched with given id, it will return nil.
    /// - Parameter id: The unique id for matching record.
    /// - Returns: The matched record or nil.
    public func fetch(id: UUID) -> AccountRecord? {
        self.table_.first {$0.id == id}
    }
}


extension Notification.Name {
    static let AccountDatabaseDidChange = Notification.Name("AccountDBDidChange")
}


extension AccountDatabase {
    static func mock() -> AccountDatabase {
        let cal = Calendar.current
        
        let recArray = [
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2020, month: 1, day: 1))!,
                category: AccountCategory(type: .income, nameSequence: ["Salary"])!,
                name: "",
                pcs: 1,
                amounts: 5000,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2020, month: 6, day: 30))!,
                category: AccountCategory(type: .outlay, nameSequence: ["Food", "Groceries"])!,
                name: "Coockie",
                pcs: 1,
                amounts: 200,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 10, day: 31))!,
                category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
                name: "",
                pcs: 1,
                amounts: 4000,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 3, day: 1))!,
                category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
                name: "",
                pcs: 1,
                amounts: 10000,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 5, day: 31))!,
                category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
                name: "",
                pcs: 1,
                amounts: 300,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 5, day: 1))!,
                category: AccountCategory(type: .outlay, nameSequence:
                                            ["Entertainments", "Hobby"]
                )!,
                name: "",
                pcs: 1,
                amounts: 2000,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 6, day: 30))!,
                category: AccountCategory(type: .income, nameSequence: ["Salary"])!,
                name: "",
                pcs: 1,
                amounts: 3000,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 8, day: 1))!,
                category: AccountCategory(type: .outlay, nameSequence:
                                            ["Food", "Groceries"]
                )!,
                name: "",
                pcs: 1,
                amounts: 20000,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 8, day: 31))!,
                category: AccountCategory(type: .outlay, nameSequence:
                                            ["Food", "Eating Out"]
                )!,
                name: "",
                pcs: 1,
                amounts: 400,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 8, day: 1))!,
                category: AccountCategory(type: .outlay, nameSequence:
                                            ["Food", "Groceries"]
                )!,
                name: "",
                pcs: 1,
                amounts: 100,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 8, day: 1))!,
                category: AccountCategory(type: .outlay, nameSequence:
                                            ["Utilities", "Gas"]
                )!,
                name: "",
                pcs: 1,
                amounts: 10,
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
