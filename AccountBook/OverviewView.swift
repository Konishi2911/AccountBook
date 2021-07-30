//
//  OverviewView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/13.
//

import SwiftUI

struct OverviewView: View {
    @State private var showingDialog = false
    
    var db: AccountDatabase
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Overview")
                .bold()
                .font(.largeTitle)
                .padding([.top, .leading, .trailing])
            BarChartView(
                source: self.barChartSource(),
                formatter: self.currencyFormatter()
            )
                .padding([.horizontal])
            HistoryView(db: self.db)
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: { self.showingDialog.toggle() } ) {
                    Image(systemName: "plus")
                }
                .popover(isPresented: self.$showingDialog) {
                    AccountEntryDialog(isShowing: self.$showingDialog)
                }
            }
        }
        .background(Color.init(.controlBackgroundColor))
    }
    
    private func currencyFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        return formatter
    }
    private func barChartSource() -> BarChartSource {
        let cal = Calendar.current
        let start = cal.date(from: cal.dateComponents([.year], from: Date()))!
        let end = cal.date(byAdding: .year, value: 1, to: start)!
        
        let aggregator = MonthlyAggregator(
            ref: self.db,
            duration: .init( start: start, end: end )
        )
        
        let result = aggregator.aggregate(
            strategy: .sum, type: .borrowing, content: { Double($0.amounts) }
        )
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "MM", options: 0, locale: nil
        )
        
        let src = result.sorted { $0.key < $1.key}
        return .init(
            labels: src.compactMap {$0.key}.map{ dateFormatter.string(from: $0.start) },
            values: [Double](src.compactMap {$0.value})
        )
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewView(db: AccountDatabase.mock())
    }
}
