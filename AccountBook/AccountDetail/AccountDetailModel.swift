//
//  AccountDetailModel.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/09/21.
//

import Foundation

class AccountDetailModel: ObservableObject {
    private let cal_ = Calendar.current
    private let ref_: AccountDatabase
    private var recID_: UUID
    
    @Published var date: Date { didSet{self.fieldsDidUpdate()} }
    @Published var type: AccountCategory.AccountType { didSet{self.typeDidUpdate()} }
    @Published var categoryName: String { didSet{self.categoryDidUpdate()} }
    @Published var subCategoryName: String { didSet{self.fieldsDidUpdate()} }
    @Published var name: String { didSet{self.fieldsDidUpdate()} }
    @Published var amount: UInt { didSet{self.fieldsDidUpdate()} }
    @Published var pcs: UInt { didSet{self.fieldsDidUpdate()} }
    @Published var remarks: String { didSet{self.fieldsDidUpdate()} }
    
    let isNew: Bool
    private var internalUpdating_: Bool = false
    
    /// Initializes Account Detail Model as new item.
    /// - Parameter ref: Database to add newly created item.
    init(ref: AccountDatabase) {
        self.ref_ = ref
        let rec = AccountRecord (
            date: Date(),
            category: AccountCategory(type: .income, nameSequence: ["Salary"])!,
            name: "",
            pcs: 0,
            amounts: 0,
            remarks: ""
        )
        
        self.date = rec.date
        self.type = rec.category.accountType
        self.categoryName = rec.category.getCategoryName(depth: 0)!
        self.subCategoryName = rec.category.getCategoryName(depth: 1) ?? ""
        self.name = rec.name
        self.amount = rec.amounts
        self.pcs = rec.pcs
        self.remarks = rec.remarks
        self.isNew = true
        self.recID_ = rec.id
        
        self.ref_.add(rec)
    }
    
    /// Initialize Account Detail Model as Edit mode
    /// - Parameters:
    ///   - record: The record editing.
    ///   - ref: Database to apply changs of the record.
    init(recordID: UUID, ref: AccountDatabase) {
        self.ref_ = ref
        self.recID_ = recordID
        
        let record = ref.fetch(id: self.recID_)!
        self.date = record.date
        self.type = record.category.accountType
        self.categoryName = record.category.getCategoryName(depth: 0)!
        self.subCategoryName = record.category.getCategoryName(depth: 1) ?? ""
        self.name = record.name
        self.amount = record.amounts
        self.pcs = record.pcs
        self.remarks = record.remarks
        self.isNew = false
    }
    
    /// Returns whether this Account Detail Model has subcategory.
    var hasSubCategory: Bool {
        self.subCategoryName != ""
    }
    
    var categoryList: [String] {
        return AccountCategoryManager(type: self.type).getChildCategoryNames()
    }
    
    var subCategoryList: [String]? {
        guard self.hasSubCategory else { return nil }
        return AccountCategoryManager(type: self.type, nameSequence: [self.categoryName])?
            .getChildCategoryNames()
    }
    
    private func fieldsDidUpdate() {
        let rec = AccountRecord (
            date: self.date,
            category: AccountCategory(
                type: self.type,
                nameSequence:
                    self.hasSubCategory ?
                    [self.categoryName, self.subCategoryName] :
                    [self.categoryName]
            )!,
            name: self.name,
            pcs: self.pcs,
            amounts: self.amount,
            remarks: self.remarks
        )
        self.ref_.replace(recordID: self.recID_, newRecord: rec)
        self.recID_ = rec.id
    }
    
    private func typeDidUpdate() {
        self.categoryName = AccountCategoryManager(type: self.type).getChildCategoryNames().first!
        self.subCategoryName = AccountCategoryManager(type: self.type, nameSequence: [self.categoryName])!.getChildCategoryNames().first ?? ""
    }
    
    private func categoryDidUpdate() {
        guard self.internalUpdating_ else { return }
        self.internalUpdating_ = true
        
        self.subCategoryName = AccountCategoryManager(type: self.type, nameSequence: [self.categoryName])!.getChildCategoryNames().first ?? ""
        
        self.internalUpdating_ = false
    }
}
