//
//  OverviewView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/13.
//

import SwiftUI

struct OverviewView: View {
    typealias AccountType = AccountCategoryProvider.AccountType
    
    @State private var accountType: AccountType = .income
    @State private var showingDialog = false
    
    var db: AccountDatabase
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Overview")
                .bold()
                .font(.largeTitle)
                .padding([.top, .leading, .trailing])
            self.content
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
    
    var content: some View {
        GeometryReader { geom in
            VStack(alignment: .leading) {
                HStack {
                    Spacer().frame(maxWidth: .infinity)
                    Picker(selection: self.$accountType, label: Text("")) {
                        Text("income").tag(AccountType.income)
                        Text("borrowing").tag(AccountType.borrowing)
                        Text("outlay").tag(AccountType.outlay)
                    }
                    .padding(.trailing, 10.0)
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 100)
                }
                BarChartView(
                    source: self.barChartSource(type: self.accountType),
                    formatter: self.currencyFormatter()
                )
                .padding([.horizontal])
                .frame(height: geom.size.height * 0.3)
                HStack {
                    HistoryView(db: self.db)
                    DetailView(
                        ref: self.db,
                        duration: DateInterval(
                            start: Calendar.current.date(from: DateComponents(year: 2021, month: 5))!,
                            end: Calendar.current.date(from: DateComponents(year: 2021, month: 6))!
                        )
                    )
                    .padding(.trailing)
                }
            }
        }
    }
    
    private func currencyFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        return formatter
    }
    private func barChartSource(type: AccountType) -> BarChartSource {
        let cal = Calendar.current
        let start = cal.date(from: cal.dateComponents([.year], from: Date()))!
        let end = cal.date(byAdding: .year, value: 1, to: start)!
        
        let records = self.db.getRecords()
            .filtered(by: DateFilter(start: start, end: end))
            .filtered(by: CategoryFilter(category: AccountCategory(type: type)))
        let aggregator = MonthlyAggregator(
            duration: .init(start: start, end: end)
        )
        
        let result = aggregator.aggregate(ref: records).summed {$0.amounts}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "MMM", options: 0, locale: nil
        )
        
        let src = result.sorted { $0.key < $1.key}
        return .init(
            labels: src.compactMap {$0.key}.map{ dateFormatter.string(from: $0.start) },
            values: [Double](src.compactMap {Double($0.value)})
        )
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewView(db: AccountDatabase.mock())
    }
}
