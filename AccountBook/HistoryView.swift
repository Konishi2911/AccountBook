//
//  HistoryView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/13.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        List {
            HistoryItem(category: "Test", amount: 500, name: "Test Name")
        }
    }
}

struct HistoryItem: View {
    let category: String
    let amount: Int
    let name: String
    private let currencyFormatter: NumberFormatter
    
    init(category: String, amount: Int, name: String) {
        self.category = category
        self.amount = amount
        self.name = name
        self.currencyFormatter = NumberFormatter()
        
        currencyFormatter.numberStyle = .currency
    }
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.right").foregroundColor(.blue)
            VStack(alignment: .leading) {
                HStack {
                    Text(category).font(.caption)
                    Text(name).font(.caption)
                }
                Text(currencyFormatter.string(from: NSNumber(value: amount))!)
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
