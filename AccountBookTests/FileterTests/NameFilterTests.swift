//
//  NameFilterTests.swift
//  AccountBookTests
//
//  Created by Kohei KONISHI on 2021/09/25.
//

import XCTest

class NameFilterTests: XCTestCase {
    let database = AccountDatabase.stub()

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
    
    func testFiltering() {
        let filter = NameFilter(string: "Cookie")
        
        let filtered = self.database.getRecords().filtered(by: filter)
        XCTAssertEqual(
            filtered.count,
            self.database.getRecords().filter {$0.name == "Cookie"}.count
        )
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        let filter = NameFilter(string: "Cookie")
        self.measure {
            // Put the code you want to measure the time of here.
            let filtered = self.database.getRecords().filtered(by: filter)
        }
    }

}
