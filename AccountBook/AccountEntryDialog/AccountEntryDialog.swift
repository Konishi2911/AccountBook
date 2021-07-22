//
//  AccountEntryDialog.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/22.
//

import SwiftUI

struct AccountEntryDialog: View {
    @State private var name: String = ""
    @State private var amount: Int = 0
    @State private var pcs: Int = 1
    @State private var bool: Bool = false
    private let currencyFormatter = NumberFormatter()
    
    init() {
        self.currencyFormatter.numberStyle = .currency
        self.currencyFormatter.currencyGroupingSeparator = ","
        self.currencyFormatter.isLenient = true
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("New Item")
                .font(.title)
                .bold()
            HStack {
                Picker("", selection: .constant(1)) {
                    Text("Income").tag(1)
                    Text("Outlay").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: 150)
                Spacer()
                DatePicker(
                    "",
                    selection: .constant(Date()),
                    displayedComponents: .date
                )
                .scaledToFit()
                .datePickerStyle(CompactDatePickerStyle())
                .frame(alignment: .trailing)
            }
            self.categoryView
            Divider()
            self.entryFieldView
        }
    }
    
    // MARK: Category View
    private var categoryView: some View {
        VStack {
            Picker(
                selection: .constant(1),
                label: Text("Category")
                    .frame(width: 100, alignment: .trailing)
                    .foregroundColor(.gray)
            ) {
                Text("Income").tag(1)
                Text("Outlay").tag(2)
            }
            .pickerStyle(MenuPickerStyle())
            Picker(
                selection: .constant(1),
                label: Text("Sub Category")
                    .frame(width: 100, alignment: .trailing)
                    .foregroundColor(.gray)
            ) {
                Text("Income").tag(1)
                Text("Outlay").tag(2)
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
    
    // MARK: EntryFieldView
    private var entryFieldView: some View {
        VStack {
            HStack {
                Text("Name")
                    .frame(width: 100, alignment: .trailing)
                    .foregroundColor(.gray)
                TextField("Enter the name", text: $name)
                    .textFieldStyle(PlainTextFieldStyle())
                Button(action: { self.bool = !self.bool }) {
                    Image(systemName: "8.square")
                        .foregroundColor( self.bool ? .blue : .black )
                }
                .buttonStyle(BorderlessButtonStyle())
                Button(action: { self.bool = !self.bool }) {
                    Image(systemName: "10.square")
                        .foregroundColor( self.bool ? .blue : .black )
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            HStack {
                Text("Amount")
                    .frame(width: 100, alignment: .trailing)
                    .foregroundColor(.gray)
                TextField("", value: $amount, formatter: self.currencyFormatter)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            Stepper(value: $pcs, in: 1...100) {
                Text("pcs")
                    .frame(width: 100, alignment: .trailing)
                    .foregroundColor(.gray)
                TextField("Pcs", value: $pcs, formatter: NumberFormatter())
                    .textFieldStyle(PlainTextFieldStyle())
            }
        }
    }
}

struct AccountEntryDialog_Previews: PreviewProvider {
    static var previews: some View {
        AccountEntryDialog()
    }
}
