//
//  HistoryItem.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/15.
//

import Foundation

class HistoryItemSource: ObservableObject {
    private let ref: AccountDatabase
    @Published var items: [HistoryItem] = []
    
    init(ref: AccountDatabase) {
        self.ref = ref
        
        updateItems(notification: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateItems(notification:)),
            name: .AccountDatabaseDidChange, object: nil
        )
    }
    
    func removeRecord(index: Int) {
        self.ref.remove(self.items[index].recordID)
    }
    
    @objc private func updateItems(notification: Notification?) {
        var tmp: [HistoryItem] = []
        for (index, rec) in self.ref
            .getRecords()
            .sorted(by: DateSotrter(.ascending))
            .getRecords()
        {
            tmp.append(.init(from: rec, id: index))
        }
        self.items = tmp
    }
}

struct HistoryItem: Identifiable {
    let id = UUID()
    
    let recordID: Int
    let date: Date
    let category: AccountCategory
    let name: String
    let amounts: UInt
    let remarks: String
    
    init(from record: AccountRecord, id: Int) {
        self.recordID = id
        self.date = record.date
        self.category = record.category
        self.name = record.name
        self.amounts = record.amounts
        self.remarks = record.remarks
    }
}
