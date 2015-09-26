//
//  MineBoard.swift
//  Sweeper
//
//  Created by Michael Chaffee on 9/24/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

import Foundation

// The MineBoard class contains all Squares of the game.
public class MineBoard {
    // MARK: - Private properties
    var squares: [MineSquare]
    var width = 0;
    var height = 0;
    var squareCount = 0;
    var mineCount = 0;
    
    // MARK: - Public properties
    public var Width: Int { get { return self.width } }
    public var Height: Int { get { return self.height } }
    public var SquareCount: Int { get { return self.squareCount } }
    
    // MARK: - Initializer
    public init(width: Int, height: Int, minePercent: Float) {
        self.width = width;
        self.height = height;
        self.squareCount = width * height;
        self.mineCount = Int(Float(self.squareCount) * minePercent);
        
        // Create a temporary bool array containing the indices of squares that will have mines.
        var mines = [Bool](count: self.squareCount, repeatedValue: false);
        for var i = 0; i < self.mineCount; i++ {
            // TODO: Prevent double-assigning to same square
            mines[Int(arc4random_uniform(UInt32(self.mineCount)))] = true
        }
        
        // Now build self.squares.
        self.squares = [MineSquare]()
        for var i = 0; i < self.squareCount; i++ {
            let coords = CoordinatesOfIndex(i)
            let square = MineSquare(inBoard: self, atX: coords.x, atY: coords.y)
            square.HasMine = mines[i]
            self.squares.append(square)
        }
        
        // Now populate the squares' Neighbor values.
        for square in self.squares {
            for var x = square.x - 1; x <= square.x + 1; x++ {
                for var y = square.y - 1; y <= square.y + 1; y++ {
                    if x != square.x || y != square.y {
                        square.AddNeighbor(self.SquareAt(x, y))
                    }
                }
            }
        }
    }
    
    // MARK: - Gameplay methods
    
    // Return an array of all squares, transformed to GameSquare structs, in an array of arrays:
    // Outer array is rows.  Inner array is squares in a row.
    // Array-of-array is populated left-to-right, top-to-bottom.
    // So Result[1][3] would give the fourth cell from the left in the second row from the top.
    public func GetBoard() -> [[GameSquare]] {
        var result = [[GameSquare]]()
        for var y = 0; y < self.height; y++ {
            var row = [GameSquare]()
            for var x = 0; x < self.width; x++ {
                row.append(GameSquare(self.SquareAt(x, y)!))
            }
            result.append(row)
        }
        return result
    }
    
    public func SquareForIndex(index: Int) -> GameSquare {
        return GameSquare(self.squares[index])
    }
    
    // Click is called when the user clicks a square.
    // - Get an array of all changed MapSquares from the target square's Click() method
    // - Transform that array into an array of GameSquares and return it
    // - Return an empty array if no squares are changed (e.g. user clicks on an already-clicked square)
    // - Return all squares with mines, if the user clicks on a mine
    public func Click(x: Int, _ y: Int) -> [GameSquare] {
        if let square = self.SquareAt(x, y) {
            let squares = square.Clicked()
            let result = squares.ToGameSquares()
            
            // This next block will only fire if the user clicked on a mine.
            if result.count == 1 && result[0].HasMine {
                return self.squares.filter({ $0.HasMine }).ToGameSquares()
            }
            
            return result
        }
        return [GameSquare]()
    }
    
    // MARK: - Helper methods

    // Return the square at x, y.  Return nil for invalid coordinates.
    func SquareAt(x: Int, _ y: Int) -> MineSquare? {
        let index = self.IndexOf(x, y)
        if index < 0 {
            return nil;
        }
        
        return self.squares[index]
    }
    
    // Return the 1-D index of the coordinates x, y
    // Return -1 for any invalid coordinates
    func IndexOf(x: Int, _ y: Int) -> Int {
        if x < 0 || x >= self.width || y < 0 || y >= self.height {
            return -1;
        }

        // the 1-d array is constructed left-to-right, top-to-bottom.
        return y * self.width + x;
    }
    
    // Return the x, y coordinates of a given 1-D index
    // Return -1, -1 for any invalid index
    func CoordinatesOfIndex(index: Int) -> (x: Int, y: Int) {
        if index < 0 || index > self.squareCount {
            return (-1, -1)
        }
        
        let y = index / self.width
        let x = index % self.width
        
        return (x, y)
    }
}

// Convert an array of MineSquares to an array of GameSquares.
extension CollectionType where Generator.Element: MineSquare {
    func ToGameSquares() -> [GameSquare] {
        return self.map({ return GameSquare($0) })
    }
}

