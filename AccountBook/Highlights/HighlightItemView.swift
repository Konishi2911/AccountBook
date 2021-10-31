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
                .foregroundColor(Color(NSColor.controlBackgroundColor))
                .shadow(radius: 2)
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
