//
//  AccountCategoryManager.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/24.
//

import Foundation

struct AccountCategoryManager {
    private let type_: AccountCategory.AccountType
    private let nameSeq_: [String]
    
    private let provider: AccountCategoryProvider
    
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
    
    func getChildCategoryList() -> [String] {
        return self.provider.categoryNames
    }
    
    func hasChildCategory() -> Bool {
        return !self.provider.isEmpty
    }
}
