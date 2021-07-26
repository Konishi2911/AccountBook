//
//  BarChartView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/16.
//

import SwiftUI

struct BarChartView: View {
    let source: BarChartSource
        
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer().frame(height:10)
                ZStack {
                    YLabelGridView(source: source)
                    BarCollection(source: source)
                }
            }
        }
    }
}

// MARK: BarCollection
private struct BarCollection: View {
    let source: BarChartSource
    let yLabelWidth: CGFloat = 30
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer().frame(width: self.yLabelWidth)
                ForEach(self.source.items) {
                    BarItemView(model: $0, height: geometry.size.height)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

// MARK: YLabelGridView
private struct YLabelGridView: View {
    let source: BarChartSource
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ForEach(0 ..< self.source.yLabels.count, id: \.self) {
                    YLabelGridItemView(
                        yValue: Double(self.source.yLabels[$0]),
                        frameSize: geometry.size,
                        order: $0,
                        nTics: self.source.yLabels.count
                    )
                }
                Spacer().frame(height: 30)
            }
        }
    }
}

// MARK: YLabelGridItemView
private struct YLabelGridItemView: View {
    let yValue: Double
    let frameSize: CGSize
    let order: Int
    let nTics: Int
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Text(yValue.description)
                    .foregroundColor(.gray)
                    .font(.callout)
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height * 0.5))
                    path.addLine(
                        to: CGPoint(x: self.frameSize.width, y: geometry.size.height * 0.5)
                    )
                }
                .stroke(style: StrokeStyle(lineWidth: 0.5, dash: [2, 2]))
                .foregroundColor(.gray)
            }
            .frame(alignment: .bottom)
            .offset(x: 0, y: self.yOffset(height: geometry.size.height))
        }
    }
    
    private func yOffset(height: CGFloat) -> CGFloat {
        let t = 1 - CGFloat(self.order) / CGFloat(self.nTics - 1)
        return 0.5 * height * (0.5 - t) * 2
    }
}

// MARK: BarItemView
private struct BarItemView: View {
    let model: BarItemModel
    let height: CGFloat
    let labelHeight: CGFloat = 30
    
    let minBarWidth: CGFloat = 5
    let maxBarWidth: CGFloat = 50
    
    var body: some View {
        let barHeight = self.height - labelHeight
        let length = model.length
        
        VStack {
            Spacer()
                .frame(height: barHeight * (1 - length))
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.blue)
                .frame(height: barHeight * length)
                .frame(minWidth: self.minBarWidth, maxWidth: self.maxBarWidth)
            Text(self.model.label).font(.body)
        }
    }
}

struct BarChartSource {
    fileprivate let items: [BarItemModel]
    let max: CGFloat
    let yMax: CGFloat
    
    init(labels: [String], values: [Double]) {
        var tmpItems: [BarItemModel] = []
        self.max = CGFloat(values.max() ?? 1)
        self.yMax = Self.roundUp(max, digits: 2)
        
        for (i, label) in labels.enumerated() {
            tmpItems.append(
                .init(
                    label: label,
                    length: CGFloat(values.indices.contains(i) ? values[i] : 0) / self.yMax,
                    rawValue: values.indices.contains(i) ? values[i] : 0
                )
            )
        }
        self.items = tmpItems
    }
    
    var yLabels: [CGFloat] {
        var arr: [CGFloat] = []
        if self.yMax.truncatingRemainder(dividingBy: 5.0) == 0 {
            for i in (0..<5).reversed() {
                arr.append(yMax * CGFloat(i) / 4)
            }
        }
        return arr
    }
    
    private static func roundUp(_ value: CGFloat, digits: UInt) -> CGFloat {
        var tmpValue = value
        var times = 0
        while(true) {
            tmpValue /= 10
            if tmpValue < pow(10, CGFloat(Double(digits))) {
                break
            } else {
                times += 1
            }
        }
        return ceil(tmpValue) * pow(10, CGFloat(Double(times + 1)))
    }
    
    static var mock: Self {
        BarChartSource(
            labels: ["TEST1", "TEST4", "TEST"],
            values: [10, 52, 25]
        )
    }
}

private struct BarItemModel: Identifiable {
    let id = UUID()
    let label: String
    let length: CGFloat
    let rawValue: Double
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(source: BarChartSource.mock)
    }
}
