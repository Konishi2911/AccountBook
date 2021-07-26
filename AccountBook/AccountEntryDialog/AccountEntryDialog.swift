//
//  AccountEntryDialog.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/22.
//

import SwiftUI

struct AccountEntryDialog: View {
    @Binding var showingSelf: Bool
    @StateObject private var model: AccountItemModel = .default
    
    @State private var bool: Bool = false
    private let currencyFormatter = NumberFormatter()
    
    init(isShowing: Binding<Bool>) {
        self._showingSelf = isShowing
        
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
                Picker("", selection: $model.type) {
                    Text("Income").tag(AccountItemModel.Direction.income)
                    Text("Borrowing").tag(AccountItemModel.Direction.borrowing)
                    Text("Outlay").tag(AccountItemModel.Direction.outlay)
                }
                .pickerStyle(SegmentedPickerStyle())
                .scaledToFit()
                .frame(alignment: .leading)
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
            HStack {
                Spacer()
                Button("Cancel") {
                    self.showingSelf = false
                }
                .keyboardShortcut(.cancelAction)
                Button("Accept") {
                    self.showingSelf = false
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(.all, 10.0)
        .frame(width: 400)
    }
    
    // MARK: Category View
    private var categoryView: some View {
        VStack {
            Picker(
                selection: $model.categoryName,
                label: Text("Category")
                    .frame(width: 100, alignment: .trailing)
                    .foregroundColor(.gray)
            ) {
                ForEach(self.model.categoryList, id: \.self) { cat in
                    Text(cat).tag(cat)
                }
            }
            .pickerStyle(DefaultPickerStyle())
            
            if model.hasSubCategory {
                Picker(
                    selection: $model.subCategoryName,
                    label: Text("Sub Category")
                        .frame(width: 100, alignment: .trailing)
                        .foregroundColor(.gray)
                ) {
                    ForEach(self.model.subCategoryList!, id: \.self) { cat in
                        Text(cat).tag(cat)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
    }
    
    // MARK: EntryFieldView
    private var entryFieldView: some View {
        VStack {
            HStack {
                Text("Name")
                    .frame(width: 100, alignment: .trailing)
                    .foregroundColor(.gray)
                TextField("Enter the name", text: $model.name)
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
                TextField("", value: $model.amount, formatter: self.currencyFormatter)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            Stepper(value: $model.pcs, in: 1...100) {
                Text("pcs")
                    .frame(width: 100, alignment: .trailing)
                    .foregroundColor(.gray)
                TextField("Pcs", value: $model.pcs, formatter: NumberFormatter())
                    .textFieldStyle(PlainTextFieldStyle())
            }
        }
    }
}

struct AccountEntryDialog_Previews: PreviewProvider {
    @State static private var bool: Bool = true

    static var previews: some View {
        AccountEntryDialog(isShowing: $bool)
    }
}
