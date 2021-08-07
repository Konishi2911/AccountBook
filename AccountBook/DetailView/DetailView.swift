//
//  DetailView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/08/05.
//

import SwiftUI

struct DetailView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Title").font(.title).fontWeight(.bold)
            HStack {
                self.totalAmounts(label: "Incomes", value: 100000)
                self.totalAmounts(label: "Outlay", value: 20000)
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
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
