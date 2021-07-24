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
        
        switch type {
        case .borrowing:
            self.provider = .borrowing
        case .income:
            self.provider = .income
        case .outlay:
            self.provider = .outlay
        }
    }
    
    init?(type: AccountCategory.AccountType, nameSequence: [String]) {
        self.type_ = type
        self.nameSeq_ = nameSequence
        
        switch type {
        case .borrowing:
            self.provider = .borrowing
        case .income:
            self.provider = .income
        case .outlay:
            self.provider = .outlay
        }
        
        if self.provider.isValid(self.nameSeq_) { return nil }
    }
    
    func getSubCategoryList() -> [String] {
        return self.provider.getSubCategory(nameSequence: self.nameSeq_).categoryNames
    }
    
    func hasSubCategory() -> Bool {
        return !self.provider.isEmpty
    }
}
