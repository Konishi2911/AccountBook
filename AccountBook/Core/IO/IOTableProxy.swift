//
//  IOTableProxy.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/08/14.
//

import Foundation

struct IOTableProxy: Codable {
    private let table_: [IORecordProxy]
    
    init(url: URL) throws {
        let decoder = JSONDecoder()
        let data = try Data(contentsOf: url)
        self.table_ = try decoder.decode([IORecordProxy].self, from: data)
    }
    
    init(base: [AccountRecord]) {
        self.table_ = base.map { return .init(base: $0) }
    }
    
    func getTable() -> [AccountRecord] {
        return self.table_.map { proxy in
            return .init(
                date: proxy.date,
                category: AccountCategory(
                    type: AccountCategoryProvider
                        .AccountType(rawValue: proxy.category.type)!,
                    nameSequence: proxy.category.nameSequence
                )!,
                name: proxy.name,
                pcs: proxy.pcs,
                amounts: proxy.amounts,
                remarks: proxy.remarks
            )
        }
    }
    
    func save(to url: URL) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self.table_)
        try data.write(to: url, options: .atomic)
    }
}

fileprivate struct IORecordProxy: Codable {
    let date: Date;
    let category: IOCategoryProxy
    let name: String
    let amounts: UInt
    let pcs: UInt
    let remarks: String
    
    init(base: AccountRecord) {
        self.date = base.date
        self.category = .init(type: base.category.accountType,
                              nameSq: base.category.categoryNameSequence)
        self.name = base.name
        self.amounts = base.amounts
        self.pcs = base.pcs
        self.remarks = base.remarks
    }
    init(date: Date, category: AccountCategory, name: String, amounts: UInt, pcs: UInt, remarks: String) {
        self.date = date
        self.category = .init(type: category.accountType,
                              nameSq: category.categoryNameSequence)
        self.name = name
        self.amounts = amounts
        self.pcs = pcs
        self.remarks = remarks
    }
}

fileprivate struct IOCategoryProxy: Codable {
    let type: String
    let nameSequence: [String]
    
    init(type: AccountCategoryProvider.AccountType, nameSq: [String]) {
        self.type = type.rawValue
        self.nameSequence = nameSq
    }
}
