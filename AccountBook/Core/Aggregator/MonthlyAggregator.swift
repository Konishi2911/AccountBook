//
//  MonthlyAggregator.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/26.
//

import Foundation

struct MonthlyAggregator: AggregatorProtocol {
    
    typealias LabelType = DateInterval
    typealias ValueType = Double
    
    private let ref_: AccountDatabase
    private let calendar_: Calendar
    private let duration_: DateInterval
    
    
    init(
        ref: AccountDatabase,
        duration: DateInterval
    ) {
        self.ref_ = ref
        self.calendar_ = Calendar.current
        self.duration_ = duration
    }
        
    func aggregate(
        strategy: AggregateStrategy<ValueType>,
        content: (AccountRecord) -> ValueType
    ) -> [LabelType: ValueType] {
        let dateFilter = DateFilter(start: self.duration_.start, end: duration_.end)
        let records = self.ref_.getRecords()
            .filtered(by: dateFilter)
            .sorted(by: DateSotrter(.ascending))
        let labels = self.createLabels()
        
        var recCnt: Int = 0
        var aggDict: [LabelType: ValueType] = [:]
        for tgtInterval in labels {
            
            let recs = records.dropFirst(recCnt)
            var aggValues: [Double] = []
            for (i, rec) in recs.enumerated() {
                guard (tgtInterval.contains(rec.date)) else {
                    recCnt = i
                    break
                }
                aggValues.append(content(rec))
            }
            aggDict[tgtInterval] = strategy.calc(contents: aggValues)
        }

        return aggDict
    }
    
    private func createLabels() -> [DateInterval] {
        var labels: [DateInterval] = []
        var monthComps = self.calendar_.dateComponents(
            [.month, .year], from: self.duration_.start
        )
        var month = self.calendar_.date(from: monthComps)!
        while month < self.duration_.end {
            let prevMonth = month
            month = self.calendar_.date(byAdding: .month, value: 1, to: month)!
            
            labels.append(.init(start: prevMonth, end: month))
        }
        
        return labels
    }
    
}
