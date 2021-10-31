//
//  HighlightsModel.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/10/01.
//

import Foundation

class HighlightsModel: ObservableObject {
    private let db_: AccountDatabase
    let currencyFormatter: NumberFormatter = .init()
    
    init(ref: AccountDatabase) {
        self.db_ = ref
        self.currencyFormatter.numberStyle = .currencyAccounting
    }
    
    func usageBarChartSource(type: AccountCategory.AccountType) -> BarChartSource {
        let cal = Calendar.current
        let start = cal.date(from: cal.dateComponents([.year], from: Date()))!
        let end = cal.date(byAdding: .year, value: 1, to: start)!
        
        let agg = MonthlyAggregator(range: start..<end)
        let rec = self.db_.getRecords()
            .filtered(by: DateFilter(start: start, end: end))
            .filtered(by: CategoryFilter(category: AccountCategory(type: type)))
        let data = agg.aggregate(ref: rec).summed { $0.amounts }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "MMM", options: 0, locale: nil
        )
        
        let labels = data
            .sorted{ $0.key.lowerBound < $1.key.lowerBound }
            .map { dateFormatter.string(from: $0.key.lowerBound) }
        let values = data
            .sorted{ $0.key.lowerBound < $1.key.lowerBound }
            .map { Double($0.value) }
        return .init( labels: labels, values: values )
    }
}
