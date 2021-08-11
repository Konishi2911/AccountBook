//
//  AccountCategoryManager.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/24.
//

import Foundation

struct AccountCategoryManager: Hashable {
    private let type_: AccountCategory.AccountType
    private let nameSeq_: [String]
    
    private let provider: AccountCategoryProvider
    
    var depth: UInt { UInt(nameSeq_.count) }
    
    init(type: AccountCategory.AccountType) {
        self.type_ = type
        self.nameSeq_ = []
        
        self.provider = self.type_.provider()
    }
    
    init?(type: AccountCategory.AccountType, nameSequence: [String]) {
        self.type_ = type
        self.nameSeq_ = nameSequence
        
        guard self.type_.provider().isValid(nameSequence) else { return nil }
        self.provider = self.type_.provider().getSubCategory(
            nameSequence: nameSequence
        )!
    }
    
    func getCategoryNameStack() -> [String] {
        return self.nameSeq_
    }
    
    func getChildCategoryNames() -> [String] {
        return self.provider.categoryNames
    }
    
    func getChildCategories() -> [AccountCategoryManager] {
        var tmp: [AccountCategoryManager] = []
        for endName in self.provider.categoryNames {
            var nameSeq = self.nameSeq_
            nameSeq.append(endName)
            tmp.append(
                AccountCategoryManager(type: self.type_, nameSequence: nameSeq)!
            )
        }
        
        return tmp
    }
    
    func hasChildCategory() -> Bool {
        return !self.provider.isEmpty
    }
    
    public func contains(_ category: AccountCategory) -> Bool {
        if self.type_ != category.accountType { return false }
        if self.nameSeq_.count == 0 { return true }
        if self.nameSeq_.count
            > category.categoryNameSequence.count { return false }
        
        for (i, cat) in self.nameSeq_.enumerated() {
            if category.categoryNameSequence[i] != cat { return false }
        }
        return true
    }
    
    
    // MARK: - Required functions to Conform to Hashable
    static func == (lhs: AccountCategoryManager, rhs: AccountCategoryManager) -> Bool {
        lhs.nameSeq_ == rhs.nameSeq_
    }
    func hash(into hasher: inout Hasher) {
        return nameSeq_.hash(into: &hasher)
    }
}
