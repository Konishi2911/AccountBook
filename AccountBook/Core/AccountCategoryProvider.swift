//
//  AccountCategoryProvider.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/11.
//

import Foundation
import OrderedCollections

struct AccountCategoryProvider {
    private let dict_: OrderedDictionary<String, AccountCategoryProvider>
    
    public var isEmpty: Bool {
        self.dict_.count == 0
    }
    
    public var categoryNames: [String] { [String](self.dict_.keys) }
    
    
    public init(_ dict: OrderedDictionary<String, AccountCategoryProvider>) {
        self.dict_ = dict
    }
    public init(_ names: [String]) {
        self.init(
            OrderedDictionary(
                uniqueKeysWithValues: zip(
                    names,
                    Array(repeating: Self.empty, count: names.count)
                )
            )
        )
    }
    
    public func subDirectory(_ name: String) -> AccountCategoryProvider? {
        if let sub = self.dict_[name] {
            guard !sub.isEmpty else { return nil }
            return sub
        } else { return nil }
    }
    
    public func isValid(_ names: [String]) -> Bool {
        guard let currentName = names.first else {
            if self.isEmpty { return true }
            else { return false }
        }
        guard let currentCategory = self.dict_[currentName] else { return false }
        let nextNames = names.dropFirst()
        
        return currentCategory.isValid(Array(nextNames))
    }
    
    public func getSubCategory(nameSequence: [String]) -> Self {
        if nameSequence.count == 0 { return self }
        else {
            return getSubCategory(nameSequence: Array(nameSequence.dropFirst()))
        }
    }
    
    
    // MARK: - Default Category Lists
    
    private static let empty = AccountCategoryProvider([:])
    static let income = AccountCategoryProvider(
        [
            "Salary": empty,
            "Other": empty
        ]
    )
    static let borrowing = AccountCategoryProvider(
        [
            "Scholarship": empty,
            "Other": empty
        ]
    )
    static let outlay = AccountCategoryProvider(
        [
            "Food": AccountCategoryProvider(
                [
                    "Groceries",
                    "Eating Out",
                    "Other"
                ]
            ),
            "Utilities": AccountCategoryProvider(
                [
                    "Gas",
                    "Water",
                    "Electricity"
                ]
            ),
            "Telecomunications": AccountCategoryProvider(
                [
                    "Internet",
                    "Cell Phone",
                    "Delivery"
                ]
            ),
            "Transportations": AccountCategoryProvider(
                [
                    "Train",
                    "Taxi",
                    "Bus",
                    "Airlines",
                    "Other"
                ]
            ),
            "Entertainments": AccountCategoryProvider(
                [
                    "Hobby",
                    "Book",
                    "Music",
                    "Other"
                ]
            ),
            "Daily Goods": AccountCategoryProvider(
                [
                    "Consumable",
                    "Other"
                ]
            ),
            "Medical": AccountCategoryProvider(
                [
                    "Hospital",
                    "Prescription",
                    "Other"
                ]
            ),
            "Home": AccountCategoryProvider(
                [
                    "Rent",
                    "Furniture",
                    "Other"
                ]
            ),
            "Education": AccountCategoryProvider(
                [
                    "Tuition",
                    "TextBook",
                    "Examination",
                    "Other"
                ]
            ),
            "Other": empty
        ]
    )
}


