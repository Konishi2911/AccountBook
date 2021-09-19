//
//  DateFileterTests.swift
//  AccountBookTests
//
//  Created by Kohei KONISHI on 2021/09/19.
//

import XCTest

class DateFileterTests: XCTestCase {
    let cal = Calendar.current
    var filter: DateFilter!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.filter = DateFilter(
            start: cal.date(from: DateComponents(year: 2021, month: 1, day: 1))!,
            end: cal.date(from: DateComponents(year: 2021, month: 7, day: 1))!
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testFilterInternal() throws {
        let record = AccountRecord(
            date: cal.date(from: DateComponents(year: 2021, month: 3, day: 1))!,
            category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
            name: "",
            pcs: 1,
            amounts: 10000,
            remarks: "None"
        )
        XCTAssert(self.filter.filter(record) != nil)
    }
    func testFilterBeginBound() throws {
        let record = AccountRecord(
            date: cal.date(from: DateComponents(year: 2021, month: 1, day: 1))!,
            category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
            name: "",
            pcs: 1,
            amounts: 10000,
            remarks: "None"
        )
        XCTAssertNotNil(self.filter.filter(record))
    }
    func testFilterBeginOutBound() throws {
        let record = AccountRecord(
            date: cal.date(from: DateComponents(year: 2020, month: 12, day: 31))!,
            category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
            name: "",
            pcs: 1,
            amounts: 10000,
            remarks: "None"
        )
        XCTAssertNil(self.filter.filter(record))
    }
    func testFilterEndBound() throws {
        let record = AccountRecord(
            date: cal.date(from: DateComponents(year: 2021, month: 6, day: 30))!,
            category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
            name: "",
            pcs: 1,
            amounts: 10000,
            remarks: "None"
        )
        XCTAssertNotNil(self.filter.filter(record))
    }
    func testFilterEndOutBound() throws {
        let record = AccountRecord(
            date: cal.date(from: DateComponents(year: 2021, month: 7, day: 1))!,
            category: AccountCategory(type: .borrowing, nameSequence: ["Scholarship"])!,
            name: "",
            pcs: 1,
            amounts: 10000,
            remarks: "None"
        )
        XCTAssertNil(self.filter.filter(record))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
