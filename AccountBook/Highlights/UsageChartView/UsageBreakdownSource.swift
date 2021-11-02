//
//  UsageBreakdownSource.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/11/02.
//

import Foundation

struct UsageBreakdownSource {
    private let source_: RecordCollection
    
    /// Analyses and provides source object for usage breakdown chart from given records.
    /// - Parameter source: a record collection to be analyzed.
    init(source: RecordCollection) {
        self.source_ = source
    }
    
    // TODO: Requires refactoring of the aggregating part
    var usageBreakdownChartSource: StackChartSource {
        let aggregator = CategoryAggregator(category: .init(type: .outlay))
        let result = aggregator.aggregate(ref: self.source_)
        return StackChartSource(
            items: Dictionary(result.summed{$0.amounts}.map {
            return ($0.key.getCategoryNameStack().last!, Double($0.value))
        }) { (first, _) in first })
    }
}
