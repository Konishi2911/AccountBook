//
//  UsageBreakdownView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/11/02.
//

import SwiftUI

struct UsageBreakdownView: View {
    private var source_: UsageBreakdownSource
    
    init(records: RecordCollection) {
        self.source_ = UsageBreakdownSource(source: records)
    }
    
    var body: some View {
        StackChartView(source: self.source_.usageBreakdownChartSource)
    }
}
