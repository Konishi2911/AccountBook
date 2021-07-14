//
//  BMTReader.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/14.
//

import Foundation

struct BMTRecord: Decodable {
    public let category: BMTCategoryValue
    public let pieces: Int
    public let remarks: String
    public let date: Date
    public let name: String
    public let amounts: Int
    
    public func toRecord() -> AccountRecord? {
        var tmpCat: AccountCategory?
        if self.category.categoryNameSequence.first! == "Scholarship" {
            tmpCat = AccountCategory(
                type: .borrowing,
                nameSequence: self.category.categoryNameSequence
            )
        } else if self.category.transactionType == .expenditure {
            tmpCat = AccountCategory(
                type: .outlay,
                nameSequence: self.category.categoryNameSequence
            )
        } else if self.category.transactionType == .income {
            tmpCat = AccountCategory(
                type: .income,
                nameSequence: self.category.categoryNameSequence
            )
        }
        guard let cat = tmpCat else { return nil }
        
        return .init(
            date: self.date,
            category: cat,
            name: self.name,
            pcs: UInt(self.pieces),
            amounts: UInt(self.amounts),
            remarks: self.remarks
        )
    }
}

struct BMTCategoryValue: Decodable {
    public let transactionType: BMTTransactionType
    public let categoryNameSequence: [String]
}

public enum BMTTransactionType: String, Codable {
    case income
    case expenditure
}
