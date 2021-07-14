//
//  AccountBookTests.swift
//  AccountBookTests
//
//  Created by Kohei KONISHI on 2021/07/11.
//

import XCTest
@testable import AccountBook

class AccountBookTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let db: AccountDatabase = .init()
        db.add(
            AccountRecord(
                date: Date(),
                category: AccountCategory(
                    type: .outlay,
                    nameSequence: ["Food", "Groceries"]
                )!,
                name: "Test1",
                pcs: 1,
                amounts: 320,
                remarks: "None"
            )
        )
        
        let recCollection = db.getRecords()
        let records = db.getRecords()
            .sorted(by: DateSotrter(.ascending))
            .getArray()
    }
    
    func testBMTDecoding() throws {
        let decoder: JSONDecoder = .init()
        let url = URL(fileURLWithPath: "/Users/koheikonishi/Library/Containers/Utilities.BudgetManager/Data/Library/Application Support/transactionTable.bmt")
        let data = try Data(contentsOf: url)
        let records = try decoder.decode([BMTRecord].self, from: data)
        print(records.count)
    }
    
    func testInitDatabaseFromBMT() throws {
        let url = URL(fileURLWithPath: "/Users/koheikonishi/Library/Containers/Utilities.BudgetManager/Data/Library/Application Support/transactionTable.bmt")
        
        var db = try AccountDatabase(fromBMT: url)
        let tmpRecCollection = db.getRecords().filtered(
            by: CategoryFilter(category: .init(type: .borrowing))
        )
        let records = tmpRecCollection.getArray()
        
        print("There are \(db.numberOfRecords) records in the DB totaly.")
        print(tmpRecCollection.count)
        print(records.count)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
