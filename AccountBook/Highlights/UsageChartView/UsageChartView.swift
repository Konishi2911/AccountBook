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
    @State private var selected: UUID?
    
    
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
        BarChartView(source: self.model_.usageBarChartSource(type: self.type_),
                     formatter: self.model_.currencyFormatter,
                     selected: self.$model_.selectedItem
        )
            .padding([.horizontal, .bottom])

    }
}

struct UsageChartView_Previews: PreviewProvider {
    static var previews: some View {
        UsageChartView(db: AccountDatabase.mock(), accountType: .outlay)
    }
}
