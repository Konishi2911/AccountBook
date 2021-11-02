//
//  HighlightsView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/09/20.
//

import SwiftUI

struct HighlightsView: View {
    private let db_: AccountDatabase
    
    init(db: AccountDatabase) {
        self.db_ = db
    }
    
    var body: some View {
        ScrollView {
            Spacer().frame(height: 10)
            HighlightItemView(title: "Outlay") {
                UsageChartView(db: self.db_, accountType: .outlay)
            }
            .frame(height: 200)
            .padding(.horizontal)
            HighlightItemView(title: "Income") {
                UsageChartView(db: self.db_, accountType: .income)
            }
            .frame(height: 200)
            .padding(.horizontal)
            HighlightItemView(title: "Borrowing") {
                UsageChartView(db: self.db_, accountType: .borrowing)
            }
            .frame(height: 200)
            .padding(.horizontal)
            Spacer().frame(height: 10)
        }
    }
    
    
}

struct HighlightsView_Previews: PreviewProvider {
    static var previews: some View {
        HighlightsView(db: .mock())
    }
}
