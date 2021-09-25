//
//  AccountDetailView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/09/21.
//

import SwiftUI

struct AccountDetailView: View {
    @ObservedObject private var model: AccountDetailModel
    @State private var bool: Bool = false
    private let currencyFormatter = NumberFormatter()
    
    init(ref: AccountDatabase) {
        self.currencyFormatter.numberStyle = .currency
        self.currencyFormatter.currencyGroupingSeparator = ","
        self.currencyFormatter.isLenient = true

        self.model = .init(ref: ref)
    }
    
    init(recordID id: UUID, ref: AccountDatabase) {
        self.currencyFormatter.numberStyle = .currency
        self.currencyFormatter.currencyGroupingSeparator = ","
        self.currencyFormatter.isLenient = true
        
        self.model = .init(recordID: id, ref: ref)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.isNew ? "New Item" : "Edit")
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
                    selection: $model.date,
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
        .padding(.all, 10.0)
        .frame(minWidth: 400)
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

struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailView(ref: .mock())
    }
}
