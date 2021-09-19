//
//  StubbedDatabase.swift
//  AccountBookTests
//
//  Created by Kohei KONISHI on 2021/09/19.
//

import Foundation

extension AccountDatabase {
    static func stub() -> AccountDatabase {
        let cal = Calendar.current
        
        let recArray = [
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2020, month: 1, day: 1))!,
                category: AccountCategory(type: .income, nameSequence: ["Salary"])!,
                name: "",
                pcs: 1,
                amounts: 5000,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2020, month: 6, day: 30))!,
                category: AccountCategory(type: .outlay, nameSequence: ["Food", "Groceries"])!,
                name: "Coockie",
                pcs: 1,
                amounts: 200,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 10, day: 31))!,
                category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
                name: "",
                pcs: 1,
                amounts: 4000,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 3, day: 1))!,
                category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
                name: "",
                pcs: 1,
                amounts: 10000,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 5, day: 31))!,
                category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
                name: "",
                pcs: 1,
                amounts: 300,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 5, day: 1))!,
                category: AccountCategory(type: .outlay, nameSequence:
                                            ["Entertainments", "Hobby"]
                )!,
                name: "",
                pcs: 1,
                amounts: 2000,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 6, day: 30))!,
                category: AccountCategory(type: .income, nameSequence: ["Salary"])!,
                name: "",
                pcs: 1,
                amounts: 3000,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 8, day: 1))!,
                category: AccountCategory(type: .outlay, nameSequence:
                                            ["Food", "Groceries"]
                )!,
                name: "",
                pcs: 1,
                amounts: 20000,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 8, day: 31))!,
                category: AccountCategory(type: .outlay, nameSequence:
                                            ["Food", "Eating Out"]
                )!,
                name: "",
                pcs: 1,
                amounts: 400,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 8, day: 1))!,
                category: AccountCategory(type: .outlay, nameSequence:
                                            ["Food", "Groceries"]
                )!,
                name: "",
                pcs: 1,
                amounts: 100,
                remarks: "None"
            ),
            AccountRecord(
                date: cal.date(from: DateComponents(year: 2021, month: 8, day: 1))!,
                category: AccountCategory(type: .outlay, nameSequence:
                                            ["Utilities", "Gas"]
                )!,
                name: "",
                pcs: 1,
                amounts: 10,
                remarks: "None"
            ),
        ]
        
        let db = AccountDatabase()
        for rec in recArray {
            db.add(rec)
        }
        return db
    }
}
