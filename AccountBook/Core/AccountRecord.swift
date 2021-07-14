//
//  AccountRecord.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/11.
//

import Foundation

struct AccountRecord: Equatable {
    public let date: Date;
    public let category: AccountCategory
    public let name: String
    public let amounts: UInt
    public let pcs: UInt
    public let remarks: String
    
    public init(date: Date, category: AccountCategory, name: String, pcs: UInt, amounts: UInt, remarks: String){
        self.date = date
        self.category = category
        self.name = name
        self.amounts = amounts
        self.pcs = pcs
        self.remarks = remarks
    }
}
