//
//  RichRoundedRectangle.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/10/31.
//

import SwiftUI


public struct RichRoundedRectangle: View, Shape {
    public func path(in rect: CGRect) -> Path {
        let radius = (self.cornerRadius > rect.width) || (self.cornerRadius > rect.height) ? min(rect.width, rect.height) * 0.5 : self.cornerRadius
        return Path { path in
            if cornerMasks.contains(.bottomLeft) || cornerMasks.contains(.bottom) || cornerMasks.contains(.left) {
                path.move(to: CGPoint(x: 0.0, y: rect.height - radius))
            } else {
                path.move(to: CGPoint(x: 0.0, y: rect.height))
            }
            if cornerMasks.contains(.topLeft) || cornerMasks.contains(.top) || cornerMasks.contains(.left) {
                path.addLine(to: CGPoint(x: 0.0, y: radius))
                path.addArc(
                    center: CGPoint(x: radius, y: radius),
                    radius: radius,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: -90),
                    clockwise: false
                )
            } else {
                path.addLine(to: CGPoint( x: 0.0, y: 0.0))
            }
            if cornerMasks.contains(.topRight) || cornerMasks.contains(.top) || cornerMasks.contains(.right) {
                path.addLine(to: CGPoint(x: rect.width - radius, y: 0.0))
                path.addArc(
                    center: CGPoint(x: rect.width - radius, y: radius),
                    radius: radius,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false
                )
            } else {
                path.addLine(to: CGPoint(x: rect.width, y: 0.0))
            }
            if cornerMasks.contains(.bottomRight) || cornerMasks.contains(.bottom) || cornerMasks.contains(.right) {
                path.addLine(to: CGPoint(
                    x: rect.width,
                    y: rect.height - radius
                ))
                path.addArc(
                    center: CGPoint(
                        x: rect.width - radius,
                        y: rect.height - radius
                    ),
                    radius: radius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false
                )
            } else {
                path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            }
            if cornerMasks.contains(.bottomLeft) || cornerMasks.contains(.bottom) || cornerMasks.contains(.left) {
                path.addLine(to: CGPoint( x: radius, y: rect.height ))
                path.addArc(
                    center: CGPoint(
                        x: radius,
                        y: rect.height - radius
                    ),
                    radius: radius,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false
                )
            } else {
                path.addLine(to: CGPoint(x: 0.0, y: rect.height))
            }
        }
}
    
    public enum CornerMask {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        
        case top
        case bottom
        case right
        case left
    }
    
    let cornerMasks: [CornerMask]
    let cornerRadius: CGFloat
    
    /*
    init(radius: CGFloat, cornerMasks: [CornerMask]) {
        self.cornerMasks_ = cornerMasks
        self.radius
    }
     */
    
    public var body: some View {
        GeometryReader { geom in
            self.path(in: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: geom.size))
        }
    }
}

struct RichRoundedRect_Previews: PreviewProvider {
    static var previews: some View {
        RichRoundedRectangle(cornerMasks: [.top], cornerRadius: 500)
    }
}
