//
//  CategoryAggregator.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/08/10.
//

import Foundation

struct CategoryAggregator: AggregatorProtocol {
    typealias LabelType = AccountCategoryManager
    typealias ValueType = Double
    
    let tgtCategory: AccountCategoryManager
    
    init(category: AccountCategoryManager) {
        self.tgtCategory = category
    }
    
    func aggregate(ref: RecordCollection) -> AggregatedItems<AccountCategoryManager> {
        let subCats = self.tgtCategory.getChildCategories()
        var agg: [LabelType: [AccountRecord]] = [:]
        
        for rec in ref {
            guard self.tgtCategory.contains(rec.category) else { continue }
            for cat in subCats {
                if cat.contains(rec.category) {
                    if agg[cat] == nil { agg[cat] = [rec] }
                    else { agg[cat]!.append(rec) }
                }
            }
        }
        return .init(records: agg)
    }
}
