//
//  UsageChartView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/11/02.
//

import SwiftUI

struct UsageChartView: View {
    private let db_: AccountDatabase
    private let type_: AccountCategory.AccountType
    
    @ObservedObject private var model_: UsageChartModel
    
    
    /// Creates as usage chart for given account type.
    /// - Parameters:
    ///   - db: a Database to refer accounts
    ///   - type: an account type to show
    init(db: AccountDatabase, accountType type: AccountCategory.AccountType) {
        self.db_ = db
        self.model_ = UsageChartModel(ref: db)
        self.type_ = type
    }
    
    var body: some View {
        VStack {
            withAnimation(.easeIn(duration: 2)) {
                BarChartView(source: self.model_.usageBarChartSource(type: self.type_),
                             formatter: self.model_.currencyFormatter,
                             selected: self.$model_.selectedItem
                )
                    .padding([.horizontal, .bottom])
                    .frame(height: 180)
            }
            if let selectedMonth = self.model_.selectedItem {
                UsageBreakdownView(
                    ref: self.db_,
                    duration: selectedMonth,
                    type: self.type_
                )
                    .padding([.horizontal, .bottom])
                    .transition(
                        .asymmetric(
                            insertion: .opacity.animation(.spring().delay(0.1)),
                            removal: .opacity
                        )
                    )
            }
        }
    }
}

struct UsageChartView_Previews: PreviewProvider {
    static var previews: some View {
        UsageChartView(db: AccountDatabase.mock(), accountType: .outlay)
    }
}
