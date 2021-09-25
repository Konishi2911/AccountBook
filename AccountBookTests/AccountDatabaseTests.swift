//
//  AccountDatabaseTests.swift
//  AccountBookTests
//
//  Created by Kohei KONISHI on 2021/09/21.
//

import XCTest

class AccountDatabaseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testRecordAddition() {
        let db = AccountDatabase()
        let rec = AccountRecord(
            date: Date(),
            category: AccountCategory(type: .income, nameSequence: ["Salary"])!,
            name: "Name",
            pcs: 1,
            amounts: 1,
            remarks: ""
        )
        
        db.add(rec)
        XCTAssertEqual(db.numberOfRecords, 1)
    }
    
    func testRecordDeletion() {
        let db = AccountDatabase()
        let rec1 = AccountRecord(
            date: Date(),
            category: AccountCategory(type: .income, nameSequence: ["Salary"])!,
            name: "Name",
            pcs: 1,
            amounts: 1,
            remarks: ""
        )
        let rec2 = AccountRecord(
            date: Date(),
            category: AccountCategory(type: .income, nameSequence: ["Salary"])!,
            name: "Name",
            pcs: 1,
            amounts: 1,
            remarks: ""
        )

        
        db.add(rec1)
        db.add(rec2)
        db.remove(recordID: rec2.id)
        
        XCTAssertEqual(db.numberOfRecords, 1)
        XCTAssertEqual(db.getRecords().first!.id, rec1.id)
    }
    
    func testRecordReplacement() {
        let db = AccountDatabase()
        let rec1 = AccountRecord(
            date: Date(),
            category: AccountCategory(type: .income, nameSequence: ["Salary"])!,
            name: "Name",
            pcs: 1,
            amounts: 1,
            remarks: ""
        )
        let rec2 = AccountRecord(
            date: Date(),
            category: AccountCategory(type: .income, nameSequence: ["Salary"])!,
            name: "Name",
            pcs: 1,
            amounts: 1,
            remarks: ""
        )

        
        db.add(rec1)
        db.replace(recordID: rec1.id, newRecord: rec2)
        
        XCTAssertEqual(db.numberOfRecords, 1)
        XCTAssertEqual(db.getRecords().first!.id, rec2.id)
    }
    
    func testRecordFetching() {
        let db = AccountDatabase()
        let rec = AccountRecord(
            date: Date(),
            category: AccountCategory(type: .income, nameSequence: ["Salary"])!,
            name: "Name",
            pcs: 1,
            amounts: 1,
            remarks: ""
        )
        
        db.add(rec)
        XCTAssertNotNil(db.fetch(id: rec.id))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
