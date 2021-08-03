//
//  HistoryView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/13.
//

import SwiftUI

struct HistoryView: View {
    let db: AccountDatabase
    
    var body: some View {
        let items = self.aggregateItems()
        
            List(0 ..< items.count) { i in
                HistoryItemView(item: items[i])
            }
    }
    
    func aggregateItems() -> [HistoryItem] {
        var items: [HistoryItem] = []
        for rec in self.db
            .getRecords()
            .sorted(by: DateSotrter(.ascending))
            .getArray() {
            items.append(.init(from: rec))
        }
        return items
    }
}

struct HistoryItemView: View {
    let item: HistoryItem
    private let currencyFormatter: NumberFormatter
    
    init(item: HistoryItem) {
        self.item = item
        
        self.currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
    }
    
    var body: some View {
        HStack {
            switch self.item.category.accountType {
            case .income:
                Image(systemName: "arrow.right").foregroundColor(.blue)
            case .borrowing:
                Image(systemName: "arrow.uturn.backward").foregroundColor(.green)
            case .outlay:
                Image(systemName: "arrow.left").foregroundColor(.red)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(self.item.category.categoryNameSequence.first!).font(.caption)
                    Text(self.item.name).font(.caption)
                }
                Text(
                    self.currencyFormatter.string(
                        from: NSNumber(value: self.item.amounts)
                    )!
                )
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(db: AccountDatabase.mock())
    }
}
