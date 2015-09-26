//
//  GameSquareTests.swift
//  Sweeper
//
//  Created by Michael Chaffee on 9/24/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

import XCTest
@testable import SweeperCore

// Here test all methods pertaining to GameSquare objects.  Therefore, generation of a GameSquare from a MineSquare, 
// generation of a GameSquare array from a MineSquare array, etc.
class GameSquareTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGameSquareInit() {
        let board = MineBoard(width: 10, height: 10, minePercent: 0.25)
        let square = board.SquareAt(5, 5)!
        
        let gameSquare = GameSquare(square)
        
        XCTAssertEqual(gameSquare.x, square.x, "X values should equal")
        XCTAssertEqual(gameSquare.y, square.y, "Y values should equal")
        XCTAssertEqual(gameSquare.NeighborMineCount, -1, "NeighborMineCount should be -1 for any unclicked")
        XCTAssertEqual(gameSquare.IsFlagged, false, "IsFlagged should be False for any unflagged")
        XCTAssertEqual(gameSquare.HasMine, false, "HasMine should be False for any unclicked")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
