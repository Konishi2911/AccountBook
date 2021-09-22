//
//  BookItem.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/09/20.
//

import Foundation

class BookItemModel: ObservableObject {
    let db: AccountDatabase
    @Published var items: [BookItem]
    
    private var selectedIndex: Int? = nil
    
    init(ref: AccountDatabase) {
        self.db = ref
        let rec = self.db.getRecords().sorted(by: DateSotrter(.ascending))
        self.items = rec.map{ BookItem(id: $0.id, ref: ref) }
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(databaseDidUpdate(notification:)),
            name: Notification.Name.AccountDatabaseDidChange, object: nil
        )
    }
        
    @objc
    func databaseDidUpdate(notification: Notification) {
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
        if let info = notification.object as? AccountDatabaseChangeInfo {
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

