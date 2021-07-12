//
//  AccountCategory.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/11.
//

import Foundation

struct AccountCategory: Equatable {
    public enum AccountType: String {
        case income
        case borrowing
        case outlay
    }
    
    public let accountType: AccountType
    public let categoryNameSequence: [String]
    
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
    
    public func getCategoryName(depth: UInt = 0) -> String {
        return self.categoryNameSequence[Int(depth)]
    }
}
