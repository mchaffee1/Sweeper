//
//  SweeperTests.swift
//  SweeperTests
//
//  Created by Michael Chaffee on 9/24/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

import XCTest
@testable import SweeperCore

class BoardBuildTests: XCTestCase {
    var board: MineBoard? = nil

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.board = MineBoard(width: 10, height: 10, minePercent: 0.25)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIndex2to1to2() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let x = 2
        let y = 2
        let index = self.board!.IndexOf(x, y)
        let coords = self.board!.CoordinatesOfIndex(index)
        XCTAssertEqual(x, coords.x, "Input x should equal output x")
        XCTAssertEqual(y, coords.y, "Input y should equal output y")
    }
    
    func testIndex1to2() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let x = 6  // this means we're in column 6 (7th column) with 6 + (y stack) preceding
        let y = 3  // this means we're in row 3 (4th row) with 30 preceding
        let properIndex = 36
        let index = self.board!.IndexOf(x, y)
        XCTAssertEqual(index, properIndex, "Hand-calculated index should equal Board-calculated index")
    }
    
    func testNeighborBuild() {
        var square = self.board!.SquareAt(0, 0)!
        XCTAssertEqual(square.Neighbors.count, 3, "Corner square should have 3 neighbors")
        square = self.board!.SquareAt(5, 9)!
        XCTAssertEqual(square.Neighbors.count, 5, "Top edge square should have 5 neighbors")
        square = self.board!.SquareAt(5, 5)!
        XCTAssertEqual(square.Neighbors.count, 8, "Middle square should have 8 neighbors")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
