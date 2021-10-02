//
//  BookItem.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/09/20.
//

import Foundation
import Combine

class BookItemModel: ObservableObject {
    let db: AccountDatabase
    var items: [BookItem] { willSet { self.objectWillChange.send() } }
    
    @Published var selectedID: UUID?
    @Published var filteringText: String = "" {
        didSet { self.filterRecord() }
    }
        
    init(ref: AccountDatabase) {
        self.db = ref
        let rec = self.db.getRecords()
            .sorted(by: DateSotrter(.ascending))
        self.items = rec.map{ BookItem(id: $0.id, ref: ref) }
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(databaseDidUpdate(notification:)),
            name: Notification.Name.AccountDatabaseDidChange, object: nil
        )
    }
        
    @objc
    func databaseDidUpdate(notification: Notification) {
        DispatchQueue.main.async {
            guard let info = notification.object as? AccountDatabaseChangeInfo else { return }
            if info.changeMode == .added {
                let rec = self.db.getRecords().sorted(by: DateSotrter(.ascending))
                self.items = rec.map{ BookItem(id: $0.id, ref: self.db) }
            }
            else if info.changeMode == .removed {
                let rec = self.db.getRecords().sorted(by: DateSotrter(.ascending))
                self.items = rec.map{ BookItem(id: $0.id, ref: self.db) }
            }
            /*
            else if info.changeMode == .replaced {
                let rec = self.db.getRecords().sorted(by: DateSotrter(.ascending))
                
                self.items = rec.map{ BookItem(id: $0.id, ref: self.db) }
                self.selected = info.prevRecord?.id
                
                print("new: \(info.newRecord?.id.description)")
                print("old: \(info.prevRecord?.id.description)")
            }
             */
        }
    }
    
    
    func createNewRecord() -> UUID {
        let rec = AccountRecord (
            date: Date(),
            category: AccountCategory(type: .income, nameSequence: ["Salary"])!,
            name: "",
            pcs: 1,
            amounts: 0,
            remarks: ""
        )
        DispatchQueue.global().async {
            self.db.add(rec)
        }
        return rec.id
    }
    
    func deleteRecord(_ indexSet: IndexSet) {
        for i in indexSet {
            self.db.remove(recordID: items[i].id)
        }
    }
    
    func filterRecord() {
        let rec = self.db.getRecords()
            .filtered(by: NameFilter(string: self.filteringText))
            .sorted(by: DateSotrter(.ascending))
        self.items = rec.map { .init(id: $0.id, ref: self.db) }
        
        self.objectWillChange.send()
    }
}

class BookItem: Identifiable, ObservableObject {
    var id: UUID
    private let ref_: AccountDatabase
    
    @Published var date: Date
    @Published var category: AccountCategory
    @Published var name: String
    @Published var amounts: UInt
    @Published var remarks: String
    
    init(id recID: UUID, ref: AccountDatabase) {
        let record = ref.fetch(id: recID)!
        
        self.id = recID
        self.ref_ = ref
        
        self.date = record.date
        self.category = record.category
        self.name = record.name
        self.amounts = record.amounts
        self.remarks = record.remarks
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(databaseDidChange(notification:)),
            name: Notification.Name.AccountDatabaseDidChange, object: nil
        )
    }
    
    @objc
    func databaseDidChange(notification: Notification) {
        DispatchQueue.main.async {
            guard let info = notification.object as? AccountDatabaseChangeInfo else { return }
            guard let prevRec = info.prevRecord else { return }
            guard let newRec = info.newRecord else { return }
            if prevRec.id == self.id {
                self.id = newRec.id
                self.date = newRec.date
                self.category = newRec.category
                self.name = newRec.name
                self.amounts = newRec.amounts
                self.remarks = newRec.remarks
            }
        }
    }
}

