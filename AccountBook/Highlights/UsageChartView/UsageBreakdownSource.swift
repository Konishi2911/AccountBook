//
//  UsageBreakdownSource.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/11/02.
//

import Foundation

struct UsageBreakdownSource {
    private let db_: AccountDatabase
    private let type_: AccountCategory.AccountType
    
    init(ref: AccountDatabase, type: AccountCategory.AccountType) {
        self.type_ = type
        self.db_ = ref
    }
    

    // TODO: Requires refactoring of the aggregating part
    func usageBreakdownChartSource(duration: Range<Date>) -> StackChartSource {
        let aggregator = CategoryAggregator(category: .init(type: self.type_))
        
        let rec = self.db_.getRecords()
            .filtered(by: DateFilter(
                start: duration.lowerBound, end: duration.upperBound
            ))
        let data = aggregator.aggregate(ref: rec)
        return StackChartSource(
            items: Dictionary(data.summed{$0.amounts}.map {
            return ($0.key.getCategoryNameStack().last!, Double($0.value))
        }) { (first, _) in first })
    }
}
