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
    
    private let duration_: DateInterval
    private let calendar_: Calendar
    
    init (duration: DateInterval) {
        self.duration_ = duration
        self.calendar_ = Calendar.current
    }
    
    func aggregate(ref: RecordCollection) -> AggregatedItems<LabelType> {
        let labels = self.createLabels()
        
        var recCnt: Int = 0
        var aggDict: [LabelType: [AccountRecord]] = [:]
        for tgtInterval in labels {
            
            let recs = ref.dropFirst(recCnt)
            var aggRecs: [AccountRecord] = []
            for (i, rec) in recs.enumerated() {
                guard (tgtInterval.contains(rec.date)) else {
                    recCnt += i
                    break
                }
                aggRecs.append(rec)
            }
            aggDict[tgtInterval] = aggRecs
        }

        return AggregatedItems(records: aggDict)
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
