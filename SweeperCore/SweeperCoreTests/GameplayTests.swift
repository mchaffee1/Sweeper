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
                    XCTAssert(clicked.Squares.count > 0, "Click() should return at least one object")
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
                if !clicked.Squares.contains({$0.x == mine.x && $0.y == mine.y}) {
                    XCTFail("Clicked does not contain a mine that is in board.mines")
                }
            }
            // TODO:  Add test for invalid entries in Clicked
        }
        else {
            XCTFail("Self.Board is NIL")
        }
    }
    
    func testFieldClearSpeed() {
        // Having a problem with large zero-fields clearing too slowly.
        // Build a board that's ALL zero-field and benchmark it.
        let board = MineBoard(width: 15, height: 18, minePercent: 0.01) // iPad Air 2 dimensions
        for var square in board.squares {
            // Placing two mines at 7, 7 and 9, 7.  
            // This means that after clearing, the square at 8, 7 will still be unclicked (and thus we don't also win)
            square.HasMine = (square.x == 7 && square.y == 7) || (square.x == 9 && square.y == 7)
        }
        board.mineCount = 1
        self.measureBlock {
                board.Click(8, 8)
        }
    }
    
    // Also having trouble with the time to "win" after clicking the last empty cell.
    func testWinSpeed() {
        let board = MineBoard(width: 15, height: 18, minePercent: 0.01) // iPad Air 2 dimensions
    }
    
}
