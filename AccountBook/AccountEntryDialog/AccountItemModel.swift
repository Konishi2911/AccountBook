//
//  AccountItem.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/23.
//

import Foundation

class AccountItemModel: ObservableObject {
    typealias Direction = AccountCategory.AccountType
    
    private var category_: String?
    private var subCategory_: String?
    
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
        
    required init(
        type: Direction,
        name: String,
        category: String? = nil,
        subCategory: String? = nil,
        amount: Int,
        pcs: Int
    ) {
        let tmpCatName = category ??
            AccountCategoryManager(type: type).getChildCategoryList().first!
        let tmpSubCatName = subCategory ??
            AccountCategoryManager(type: type, nameSequence: [tmpCatName])?
            .getChildCategoryList().first ?? ""
        
        self.type = type
        self.name = name
        self.categoryName = tmpCatName
        self.subCategoryName = tmpSubCatName
        self.amount = amount
        self.pcs = pcs
    }
    
    var hasSubCategory: Bool {
        return AccountCategoryManager(
            type: self.type,
            nameSequence: [self.categoryName]
        )?.hasChildCategory() ?? false
    }
    
    var categoryList: [String] {
        return AccountCategoryManager(type: self.type).getChildCategoryList()
    }
    
    var subCategoryList: [String]? {
        guard self.hasSubCategory else { return nil }
        
        return AccountCategoryManager(type: self.type, nameSequence: [self.categoryName])?
            .getChildCategoryList()
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
            type: .income,
            name: "",
            category: "Salary",
            amount: 0,
            pcs: 1
        )
    }
}
