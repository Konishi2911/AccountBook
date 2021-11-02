//
//  HighlightItemView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/10/02.
//

import SwiftUI

struct HighlightItemView<ViewType>: View where ViewType: View{
    let view: ViewType
    let title: String?
    
    init(title: String? = nil, content: () -> ViewType) {
        self.view = content()
        self.title = title
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(NSColor.controlBackgroundColor))
                .shadow(color: Color(.sRGBLinear, white: 0.0, opacity: 0.2), radius: 5)
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(NSColor.systemGray), lineWidth: 0.3)
            VStack(alignment: .leading) {
                if let titleStr = self.title {
                    Text(titleStr)
                        .font(.title)
                        .padding([.top, .leading])
                }
                self.view
            }
        }
    }
}

struct HighlightItemView_Previews: PreviewProvider {
    static var previews: some View {
        HighlightItemView {
            Text("TEST")
        }
    }
}
