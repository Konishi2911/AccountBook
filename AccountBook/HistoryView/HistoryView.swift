//
//  HistoryView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/13.
//

import SwiftUI

struct HistoryView: View {
    @State private var selected: UUID? = nil
    @ObservedObject private var ref: HistoryItemSource
    
    
    init (db: AccountDatabase) {
        self.ref = .init(ref: db)
    }
    
    var body: some View {
        List(selection: self.$selected) {
            ForEach(self.ref.items) { item in
                HistoryItemView(item: item)
            }
            .onDelete(perform: { index in
                self.ref.removeRecord(index: index.first!)
            })
        }
    }
}

struct HistoryItemView: View {
    let item: HistoryItem
    private let currencyFormatter: NumberFormatter
    private let dateFormatter: DateFormatter
    
    init(item: HistoryItem) {
        self.item = item
        
        self.currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "MMMdd", options: 0, locale: nil
        )
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
                    Text(self.dateFormatter.string(from: self.item.date)).font(.caption)
                    Text(self.item.category.categoryNameSequence.first!)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                    Text(self.item.name)
                        .font(.caption)
                        .foregroundColor(.gray)
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
