//
//  MonthlyAggregator.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/26.
//

import Foundation

struct MonthlyAggregator: AggregatorProtocol {
    
    typealias LabelType = Range<Date>
    typealias ValueType = Double
    
    private let duration_: Range<Date>
    private let calendar_: Calendar = .current
    
    init (range: Range<Date>) {
        self.duration_ = range
    }
    
    @available(*, deprecated)
    init (duration: DateInterval) {
        self.duration_ = duration.start ..< duration.end
    }
    
    func aggregate(ref: RecordCollection) -> AggregatedItems<LabelType> {
        let labels = self.createLabels()
        let sortedRef = ref.sorted(by: DateSotrter(.ascending))
        
        var recCnt: Int = 0
        var aggDict: [LabelType: [AccountRecord]] = [:]
        for tgtInterval in labels {
            let recs = sortedRef.dropFirst(recCnt)
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
    
    private func createLabels() -> [Range<Date>] {
        var labels: [Range<Date>] = []
        let monthComps = self.calendar_.dateComponents(
            [.month, .year], from: self.duration_.lowerBound
        )
        var month = self.calendar_.date(from: monthComps)!
        while month < self.duration_.upperBound {
            let prevMonth = month
            month = self.calendar_.date(byAdding: .month, value: 1, to: month)!
            
            labels.append(prevMonth ..< month)
        }
        
        return labels
    }
    
}
