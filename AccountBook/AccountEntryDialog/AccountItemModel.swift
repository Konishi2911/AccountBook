//
//  AccountItem.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/23.
//

import Foundation

class AccountItemModel: ObservableObject {
    typealias Direction = AccountCategory.AccountType
    
    @Published var date: Date
    @Published var type: Direction {
        didSet { if self.type != oldValue { self.updateCategory() } }
    }
    @Published var categoryName: String {
        didSet { if self.categoryName != oldValue { self.updateSubCateogory() } }
    }
    @Published var subCategoryName: String
    @Published var name: String
    @Published var amount: Int = 0
    @Published var pcs: Int
    @Published var remarks: String
        
    required init(
        date: Date,
        type: Direction,
        name: String,
        category: String? = nil,
        subCategory: String? = nil,
        amount: Int,
        pcs: Int,
        remarks: String
    ) {
        let tmpCatName = category ??
            AccountCategoryManager(type: type).getChildCategoryNames().first!
        let tmpSubCatName = subCategory ??
            AccountCategoryManager(type: type, nameSequence: [tmpCatName])?
            .getChildCategoryNames().first ?? ""
        
        self.date = date
        self.type = type
        self.name = name
        self.categoryName = tmpCatName
        self.subCategoryName = tmpSubCatName
        self.amount = amount
        self.pcs = pcs
        self.remarks = remarks
    }
    
    var hasSubCategory: Bool {
        return AccountCategoryManager(
            type: self.type,
            nameSequence: [self.categoryName]
        )?.hasChildCategory() ?? false
    }
    
    var categoryList: [String] {
        return AccountCategoryManager(type: self.type).getChildCategoryNames()
    }
    
    var subCategoryList: [String]? {
        guard self.hasSubCategory else { return nil }
        
        return AccountCategoryManager(type: self.type, nameSequence: [self.categoryName])?
            .getChildCategoryNames()
    }
    
    func toAccountRecord() -> AccountRecord {
        return .init(
            date: self.date,
            category: AccountCategory(
                type: self.type,
                nameSequence: [self.categoryName, self.subCategoryName])!,
            name: self.name,
            pcs: UInt(self.pcs),
            amounts: UInt(self.amount),
            remarks: self.remarks
        )
    }
    
    private func updateCategory() {
        self.categoryName = self.categoryList.first!
        print("Category Updated")
    }
    private func updateSubCateogory() {
        self.subCategoryName = self.subCategoryList?.first ?? ""
    }
    
    static var `default`: Self {
        .init(
            date: Date(),
            type: .income,
            name: "",
            category: "Salary",
            amount: 0,
            pcs: 1,
            remarks: ""
        )
    }
}
