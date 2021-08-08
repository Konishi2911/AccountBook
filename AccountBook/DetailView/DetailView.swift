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
                self.totalAmounts(label: "Incomes", value: self.incomeAmounts)
                self.totalAmounts(label: "Outlay", value: self.outlayAmounts)
            }
        }
    }
    
    func totalAmounts(label: String, value: Int) -> some View {
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        
        return VStack {
            HStack {
                Text(label)
                Text(fmt.string(from: NSNumber(value: value))!)
            }
            Rectangle()
                .foregroundColor(.gray)
                .padding([.horizontal, .bottom])
        }
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
