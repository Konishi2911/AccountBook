//
//  UsageChartModel.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/11/02.
//

import Foundation

class UsageChartModel: ObservableObject {
    private let db_: AccountDatabase
    
    @Published var selectedItem: MonthlyAggregator.LabelType?
    
    
    let currencyFormatter: NumberFormatter = .init()
    
    init(ref: AccountDatabase) {
        self.db_ = ref
        self.currencyFormatter.numberStyle = .currencyAccounting
    }
    
    func usageBarChartSource(type: AccountCategory.AccountType) -> BarChartSource<MonthlyAggregator.LabelType> {
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
        
        let sorted = data.sorted{ $0.key.lowerBound < $1.key.lowerBound }
        return BarChartSource(source: sorted.map{
            SelectableBarChartItemSource(
                id: $0.key,
                label: dateFormatter.string(from: $0.key.lowerBound),
                value: Double($0.value)
            )
        })
    }
}
