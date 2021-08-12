//
//  DetailView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/08/05.
//

import SwiftUI

struct DetailView: View {
    private let cal_: Calendar = .autoupdatingCurrent
    private let ref_: AccountDatabase
    @State private var duration: DateInterval = .init()
    
    init (ref: AccountDatabase, duration: DateInterval) {
        self.ref_ = ref
        self.duration = duration
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(self.title).font(.title).fontWeight(.bold)
                    .padding()
                Spacer()
                Button(action: { self.shiftDuration(value: -1) }) {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(PlainButtonStyle())
                Button(action: { self.shiftDuration(value: 1) }) {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(PlainButtonStyle())
                .padding([.trailing])
            }
            HStack {
                self.totalAmounts(
                    label: "Incomes",
                    source: self.calcSource(
                        aggregator: CategoryAggregator(category: AccountCategoryManager(type: .income))
                    )
                )
                self.totalAmounts(
                    label: "Outlay",
                    source: self.calcSource(
                        aggregator: CategoryAggregator(category: AccountCategoryManager(type: .outlay))
                    )
                )
            }
        }
    }
    
    private func calcSource(aggregator: CategoryAggregator) -> [String: Double] {
        let agg = aggregator.aggregate(
            ref: self.ref_.getRecords()
                .filtered(by: DateFilter(start: self.duration.start, end: self.duration.end))
        )
        let tmp = agg.summed { $0.amounts }
        return Dictionary(tmp.map {
            return ($0.key.getCategoryNameStack().last!, Double($0.value))
        }) { (first, _) in first }
    }
    
    func totalAmounts(label: String, source: [String: Double]) -> some View {
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        
        let total = source.reduce(0){$0 + $1.value}
        
        return VStack {
            HStack {
                Text(label).font(.title3).bold()
                Text(fmt.string(from: NSNumber(value: total))!).font(.title3)
            }
            StackChartView(source: StackChartSource(items: source),
                           colorMap: .blue,
                           formatter: fmt)
        }
        .padding(.horizontal)
    }
    func shiftDuration(value: Int) {
        let newStartDate = self.cal_.date(
            byAdding: .month, value: value, to: self.duration.start
        )!
        self.duration = DateInterval(
            start: newStartDate,
            end: self.cal_.date(byAdding: .month, value: 1, to: newStartDate)!
        )
    }
    
    var title: String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "yyyMMMM", options: 0, locale: nil
        )
        
        return formatter.string(from: self.duration.start)
    }
    var incomeAmounts: Int {
        let recs = self.ref_.getRecords()
            .filtered(by: DateFilter(start: self.duration.start, end: self.duration.end))
            .filtered(by: CategoryFilter(category: AccountCategory(type: .income)))
            .getArray()
        return Int(recs.reduce(0) {$0 + $1.amounts})
    }
    var outlayAmounts: Int {
        let recs = self.ref_.getRecords()
            .filtered(by: DateFilter(start: self.duration.start, end: self.duration.end))
            .filtered(by: CategoryFilter(category: AccountCategory(type: .outlay)))
            .getArray()
        return Int(recs.reduce(0) {$0 + $1.amounts})
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let cal = Calendar.current
        DetailView(
            ref: AccountDatabase.mock(),
            duration: DateInterval(
                start: cal.date(from: DateComponents(year: 2021, month: 5))!,
                end: cal.date(from: DateComponents(year: 2021, month: 6))!
            )
        )
    }
}
