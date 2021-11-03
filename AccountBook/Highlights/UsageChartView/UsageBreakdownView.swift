//
//  UsageBreakdownView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/11/02.
//

import SwiftUI

struct UsageBreakdownView: View {
    private let source_: UsageBreakdownSource
    private let duration_: Range<Date>
    
    init(ref: AccountDatabase, duration: Range<Date>, type: AccountCategory.AccountType) {
        self.source_ = UsageBreakdownSource(ref: ref, type: type)
        self.duration_ = duration
    }
    
    var body: some View {
        StackChartView(
            source: self.source_.usageBreakdownChartSource(duration: self.duration_)
        )
    }
}
