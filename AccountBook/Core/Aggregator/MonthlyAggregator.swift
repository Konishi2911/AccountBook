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
    
    private let ref_: RecordCollection
    private let duration_: DateInterval
    private let calendar_: Calendar
    
    @available(*, deprecated)
    init(
        ref: AccountDatabase,
        duration: DateInterval
    ) {
        self.ref_ = ref.getRecords()
            .filtered(
                by: DateFilter(start: duration.start, end: duration.end)
            )
            .sorted(by: DateSotrter(.ascending))
        self.duration_ = duration
        self.calendar_ = Calendar.current
    }
    
    init (ref: RecordCollection, duration: DateInterval) {
        self.ref_ = ref
        self.duration_ = duration
        self.calendar_ = Calendar.current
    }
    
    func aggregate() -> AggregatedItems<LabelType> {
        let labels = self.createLabels()
        
        var recCnt: Int = 0
        var aggDict: [LabelType: RecordCollection] = [:]
        for tgtInterval in labels {
            
            let recs = self.ref_.dropFirst(recCnt)
            var aggRecs: [AccountRecord] = []
            for (i, rec) in recs.enumerated() {
                guard (tgtInterval.contains(rec.date)) else {
                    recCnt += i
                    break
                }
                aggRecs.append(rec)
            }
            aggDict[tgtInterval] = recs
        }

        return AggregatedItems(records: aggDict)
    }
        
    func aggregate(
        strategy: AggregateStrategy<ValueType>,
        type: AccountCategoryProvider.AccountType,
        content: (AccountRecord) -> ValueType
    ) -> [LabelType: ValueType] {
        let labels = self.createLabels()
        
        var recCnt: Int = 0
        var aggDict: [LabelType: ValueType] = [:]
        for tgtInterval in labels {
            
            let recs = self.ref_.dropFirst(recCnt)
            var aggValues: [Double] = []
            for (i, rec) in recs.enumerated() {
                guard (tgtInterval.contains(rec.date)) else {
                    recCnt += i
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
        let monthComps = self.calendar_.dateComponents(
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
