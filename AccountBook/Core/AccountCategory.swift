//
//  AccountCategory.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/11.
//

import Foundation

struct AccountCategory: Equatable, Hashable {
    typealias AccountType = AccountCategoryProvider.AccountType
    
    public let accountType: AccountType
    public let categoryNameSequence: [String]
    
    public init(type: AccountType) {
        self.accountType = type
        self.categoryNameSequence = []
    }
    
    public init?(type: AccountType, nameSequence: [String]) {
        switch type {
        case .income:
            guard AccountCategoryProvider.income.isValid(nameSequence) else {
                return nil
            }
        case .borrowing:
            guard AccountCategoryProvider.borrowing.isValid(nameSequence) else {
                return nil
            }
        case .outlay:
            guard AccountCategoryProvider.outlay.isValid(nameSequence) else {
                return nil
            }
        }
        
        self.accountType = type
        self.categoryNameSequence = nameSequence
    }
    
    public func isIncluded(in category: Self) -> Bool {
        if self.accountType != category.accountType { return false }
        if category.categoryNameSequence.count == 0 { return true }
        if self.categoryNameSequence.count
            < category.categoryNameSequence.count { return false }
        
        for (i, cat) in self.categoryNameSequence.enumerated() {
            if category.categoryNameSequence[i] != cat { return false }
        }
        return true
    }
    
    public func getCategoryName(depth: UInt = 0) -> String? {
        guard self.categoryNameSequence.count > depth else { return nil }
        return self.categoryNameSequence[Int(depth)]
    }
}
