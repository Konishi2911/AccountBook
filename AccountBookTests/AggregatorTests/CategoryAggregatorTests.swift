//
//  CategoryAggregatorTests.swift
//  AccountBookTests
//
//  Created by Kohei KONISHI on 2021/09/19.
//

import XCTest

class CategoryAggregatorTests: XCTestCase {
    var incomeAggregator: CategoryAggregator!
    var borrowingAggregator: CategoryAggregator!
    var outlayAggregator: CategoryAggregator!


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.incomeAggregator = CategoryAggregator(
            category: AccountCategoryManager.init(type: .income)
        )
        self.borrowingAggregator = CategoryAggregator(
            category: AccountCategoryManager.init(type: .borrowing)
        )
        self.outlayAggregator = CategoryAggregator(
            category: AccountCategoryManager.init(type: .outlay)
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testIncomeAggregation() throws {
        let agg = self.incomeAggregator.aggregate(ref: AccountDatabase.stub().getRecords())
        let exact: [(String, UInt)] = [
            ("Salary", 8000)
        ]
        let tmp: [(String, UInt)] = agg.summed{$0.amounts}.sorted{
            $0.key.getCategoryNameStack().last! < $1.key.getCategoryNameStack().last!
        }.map { ($0.key.getCategoryNameStack().last!, $0.value) }
        
        XCTAssert(
            tmp.map{$0.1} == exact.map{$0.1} &&
            tmp.map{$0.0} == exact.map{$0.0}
        )
    }
    func testBorrowingAggregation() throws {
        let agg = self.borrowingAggregator.aggregate(ref: AccountDatabase.stub().getRecords())
        let exact: [(String, UInt)] = [
            ("Scholarship", 14300)
        ]
        let tmp: [(String, UInt)] = agg.summed{$0.amounts}.sorted{
            $0.key.getCategoryNameStack().last! < $1.key.getCategoryNameStack().last!
        }.map { ($0.key.getCategoryNameStack().last!, $0.value) }
        
        XCTAssert(
            tmp.map{$0.1} == exact.map{$0.1} &&
            tmp.map{$0.0} == exact.map{$0.0}
        )
    }
    func testOutlayAggregation() throws {
        let agg = self.outlayAggregator.aggregate(ref: AccountDatabase.stub().getRecords())
        let exact: [(String, UInt)] = [
            ("Entertainments", 2000),
            ("Food", 20700),
            ("Utilities", 10),
        ]
        let tmp: [(String, UInt)] = agg.summed{$0.amounts}.sorted{
            $0.key.getCategoryNameStack().last! < $1.key.getCategoryNameStack().last!
        }.map { ($0.key.getCategoryNameStack().last!, $0.value) }
        
        XCTAssert(
            tmp.map{$0.1} == exact.map{$0.1} &&
            tmp.map{$0.0} == exact.map{$0.0}
        )
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
