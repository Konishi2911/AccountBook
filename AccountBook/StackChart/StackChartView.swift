//
//  StackChartView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/08/08.
//

import SwiftUI

struct StackChartView: View {
    private let chartWidth: CGFloat = 10
    
    let source: StackChartSource
    let valueFormatter: NumberFormatter
    let order: StackChartSource.Direction
    
    
    init(source: StackChartSource,
         colorMap: ColorMap = .blue,
         formatter: NumberFormatter = .init(),
         order: StackChartSource.Direction = .descending
    ) {
        self.source = .init(items: source.items, colorMap: colorMap)
        self.valueFormatter = formatter
        self.order = order
    }
    
    var body: some View {
        VStack(alignment: .center) {
            self.stackChart().padding(5)
            self.legends()
        }
    }
    
    func stackChart() -> some View {
        GeometryReader {geom in
            HStack(spacing: 0) {
                let items = self.source.items(sortedBy: self.order)
                if items.count == 1 {
                    RichRoundedRectangle(
                        cornerMasks: [.left, .right],
                        cornerRadius: self.chartWidth / 2
                    )
                        .fill(Color(items.first!.color))
                    .frame(
                        width: barWidth(value: items.first!.tuple.1, viewWidth: geom.size.width),
                        height: self.chartWidth
                    )
                } else {
                    RichRoundedRectangle(
                        cornerMasks: [.left],
                        cornerRadius: self.chartWidth / 2
                    )
                        .fill(Color(items.first!.color))
                    .frame(
                        width: barWidth(value: items.first!.tuple.1, viewWidth: geom.size.width),
                        height: self.chartWidth
                    )
                    ForEach(items[1..<items.count - 1]) { item in
                        Rectangle()
                            .fill(Color(item.color))
                            .frame(
                                width: barWidth(value: item.tuple.1, viewWidth: geom.size.width),
                                height: self.chartWidth
                            )
                    }
                    RichRoundedRectangle(
                        cornerMasks: [.right],
                        cornerRadius: self.chartWidth / 2
                    )
                        .fill(Color(items.last!.color))
                    .frame(
                        width: barWidth(value: items.last!.tuple.1, viewWidth: geom.size.width),
                        height: self.chartWidth
                    )
                }
            }
        }.frame(height: self.chartWidth)
    }
    
    func legends() -> some View {
        ScrollView(.horizontal) {
            HStack(alignment: .center) {
                ForEach(self.source.items(sortedBy: self.order)) {
                    self.legendItem(item: $0)
                }
                .padding(.trailing)
            }
            .padding(.bottom)
        }
        .padding([.horizontal])
    }
    
    func legendItem(item: StackChartSource.Item<Double>) -> some View {
        HStack {
            Circle()
                .fill(Color(item.color))
                .frame(width: 10, height: 10)
            Text(
                item.tuple.0 + ": " +
                self.valueFormatter.string(from: NSNumber(value: Int(item.tuple.1)))!
            )
            .font(.caption)
        }
    }
    
    func barWidth(value: Double, viewWidth: CGFloat) -> CGFloat {
        CGFloat(value / self.source.total) * viewWidth
    }
}

struct StackChartView_Previews: PreviewProvider {
    static var previews: some View {
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        let source = StackChartSource(
            items: [
                "test": 243.0,
                "TEST": 453,
                "Test": 343
            ],
            colorMap: .green
        )
        return StackChartView(source: source, formatter: fmt)
    }
}
