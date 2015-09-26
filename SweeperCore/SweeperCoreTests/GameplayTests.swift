//
//  GameplayTests.swift
//  Sweeper
//
//  Created by Michael Chaffee on 9/24/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

import XCTest
@testable import SweeperCore

class GameplayTests: XCTestCase {
    var board: MineBoard?
    
    override func setUp() {
        super.setUp()
        
        self.board = MineBoard(width: 10, height: 10, minePercent: 0.25)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testClickEmpty() {
        if let board = self.board {
            // Find a square that doesn't have a mine, click it, see that the returned object is correct.
            for var index = 0; index < board.Width * board.Height; index++ {
                let xy = board.CoordinatesOfIndex(index)
                let square = board.SquareAt(xy.x, xy.y)!
                if !square.HasMine {
                    let clicked = board.Click(xy.x, xy.y)  // clicked should now contain an array of >0 GameSquares including the square we traversed to.
                    XCTAssert(clicked.count > 0, "Click() should return at least one object")
                    return
                }
            }
            
            // TODO:  Add test for neighbor behavior
        }
        else {
            XCTFail("Self.Board is NIL")
        }
    }
    
    func testClickMine() {
        if let board = self.board {
            // Find a square that doesn't have a mine, click it, see that the returned object is correct.
            var square: MineSquare?
            for var index = 0; index < board.Width * board.Height; index++ {
                let xy = board.CoordinatesOfIndex(index)
                square = board.SquareAt(xy.x, xy.y)!
                if square!.HasMine {
                    break
                }
            }
            
            // At this point, var square is populated with the first mine on the board.  We're gonna click it and make sure we get a valid list of mines.
            let clicked = board.Click(square!.x, square!.y)
            var mines = [MineSquare]()
            for var mine in board.squares {
                if mine.HasMine { mines.append(mine) }
            }
            
            for var mine in mines {
                if !clicked.contains({$0.x == mine.x && $0.y == mine.y}) {
                    XCTFail("Clicked does not contain a mine that is in board.mines")
                }
            }
            // TODO:  Add test for invalid entries in Clicked
        }
        else {
            XCTFail("Self.Board is NIL")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
