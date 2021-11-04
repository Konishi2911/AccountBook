//
//  MonthlyAggregatorTests.swift
//  AccountBookTests
//
//  Created by Kohei KONISHI on 2021/09/19.
//

import XCTest

class MonthlyAggregatorTests: XCTestCase {
    let cal: Calendar = .current
    var aggregator: MonthlyAggregator!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        /*
        self.aggregator = MonthlyAggregator(
            duration: DateInterval(
                start: cal.date(from: DateComponents(year: 2020, month: 1, day: 1))!,
                end: cal.date(from: DateComponents(year: 2022, month: 1, day: 1))!
            )
        )
         */
        self.aggregator = MonthlyAggregator(
            range:
                cal.date(from: DateComponents(year: 2020, month: 1, day: 1))! ..<
                cal.date(from: DateComponents(year: 2022, month: 1, day: 1))!
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAggregatedItemCount() throws {
        let agg = aggregator.aggregate(ref: AccountDatabase.stub().getRecords())
        XCTAssertEqual(agg.count, 24)
    }
    
    func testSumAggregation() throws {
        let recCollection = AccountDatabase.stub().getRecords()
        let agg = aggregator.aggregate(ref: recCollection)
        let exact: [UInt] = [
            5000, 0, 0, 0, 0, 200, 0, 0, 0, 0, 0, 0,
            0, 0, 10000, 0, 2300, 3000, 0, 20510, 0, 4000, 0, 0
        ]
        
        XCTAssertEqual(
            agg.summed{ $0.amounts }.sorted {$0.key.lowerBound < $1.key.lowerBound}.map{$1},
            exact
        )
    }
    
    func testAverageAggregation() throws {
        let agg = aggregator.aggregate(ref: AccountDatabase.stub().getRecords())
        let exact: [Double] = [
            5000, 0, 0, 0, 0, 200, 0, 0, 0, 0, 0, 0,
            0, 0, 10000, 0, 1150, 3000, 0, 5127.5, 0, 4000, 0, 0
        ]
        
        XCTAssertEqual(
            agg.averaged{ Double($0.amounts) }.sorted {$0.key.lowerBound < $1.key.lowerBound}.map{$1},
            exact
        )
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
