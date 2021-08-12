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
    
    
    init(source: StackChartSource,
         colorMap: ColorMap = .blue,
         formatter: NumberFormatter = .init()
    ) {
        self.source = .init(items: source.items, colorMap: colorMap)
        self.valueFormatter = formatter
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
                ForEach(self.source.items(sortedBy: .ascending)) {
                    RoundedRectangle(cornerRadius: self.chartWidth / 2)
                        .frame(
                            width: barWidth(value: $0.tuple.1, viewWidth: geom.size.width),
                            height: self.chartWidth
                        )
                        .foregroundColor(Color($0.color))
                }
            }
        }.frame(height: self.chartWidth)
    }
    
    func legends() -> some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                ForEach(self.source.items(sortedBy: .ascending)) {
                    self.legendItem(item: $0)
                }
            }
        }
    }
    
    func legendItem(item: StackChartSource.Item<Double>) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(maxWidth: 20)
                .frame(height: 10)
                .foregroundColor(Color(item.color))
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
