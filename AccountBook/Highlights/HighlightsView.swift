//
//  HighlightsView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/09/20.
//

import SwiftUI

struct HighlightsView: View {
    let model: HighlightsModel
    
    init(db: AccountDatabase) {
        self.model = .init(ref: db)
    }
    
    var body: some View {
        ScrollView {
            Spacer().frame(height: 10)
            HighlightItemView(title: "Outlay") {
                BarChartView(source: self.model.usageBarChartSource(type: .outlay),
                             formatter: self.model.currencyFormatter)
                    .padding([.horizontal, .bottom])
            }
            .frame(height: 200)
            .padding(.horizontal)
            HighlightItemView(title: "Income") {
                BarChartView(source: self.model.usageBarChartSource(type: .income),
                             formatter: self.model.currencyFormatter)
                    .padding([.horizontal, .bottom])
            }
            .frame(height: 200)
            .padding(.horizontal)
            HighlightItemView(title: "Borrowing") {
                BarChartView(source: self.model.usageBarChartSource(type: .borrowing),
                             formatter: self.model.currencyFormatter)
                    .padding([.horizontal, .bottom])
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
