//
//  MineBoard.swift
//  Sweeper
//
//  Created by Michael Chaffee on 9/24/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

import Foundation
import CoreFoundation  // This is here to get a performance time measurement

// The MineBoard class contains all Squares of the game.
public class MineBoard {
  // MARK: - Internal properties
  var squares: [MineSquare]
  var _width = 0;
  var _height = 0;
  var _squareCount = 0;
  var mineCount = 0;
  var gameState = GameState.Unstarted
  
  // MARK: - Public properties
  public var width: Int { get { return self._width } }
  public var height: Int { get { return self._height } }
  public var squareCount: Int { get { return self._squareCount } }
  public var gameSquares: [GameSquare] { get { return self.squares.toGameSquares() } }
  
  // MARK: - Initializer
  public init(width: Int, height: Int, minePercent: Float) {
    self._width = width;
    self._height = height;
    self._squareCount = width * height;
    self.mineCount = Int(Float(self._squareCount) * minePercent);
    
    // Create a temporary bool array containing the indices of squares that will have mines.
    var mines = [Bool](count: self._squareCount, repeatedValue: false);
    for var i = 0; i < self.mineCount; i++ {
      // TODO: Prevent double-assigning to same square
      mines[Int(arc4random_uniform(UInt32(self._squareCount)))] = true
    }
    
    // Now build self.squares.
    self.squares = [MineSquare]()
    for var i = 0; i < self.squareCount; i++ {
      let coords = coordinatesOfIndex(i)
      let square = MineSquare(atX: coords.x, atY: coords.y, atIndex: i)
      square.hasMine = mines[i]
      self.squares.append(square)
    }
    
    // Now populate the squares' Neighbor values.
    for square in self.squares {
      for var x = square.x - 1; x <= square.x + 1; x++ {
        for var y = square.y - 1; y <= square.y + 1; y++ {
          if x != square.x || y != square.y {
            square.AddNeighbor(self.squareAt(x, y))
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
  public func getBoard() -> [[GameSquare]] {
    var result = [[GameSquare]]()
    for var y = 0; y < height; y++ {
      var row = [GameSquare]()
      for var x = 0; x < width; x++ {
        row.append(GameSquare(squareAt(x, y)!))
      }
      result.append(row)
    }
    return result
  }
  
  // Return the square at the linear index "index"
  // Recall that linear index traverses the board Left-to-right, top-to-bottom.
  public func squareForIndex(index: Int) -> GameSquare {
    return GameSquare(squares[index])
  }
  
  // Call Click when a user clicks a square and it's referenced by 2-d coordinates.
  public func click(x: Int, _ y: Int) -> GameStatus {
    if let square = squareAt(x, y) {
      return clickSquare(square)
    }
    return GameStatus(gameState)
  }
  
  // Call Click1d when a user clicks a square and it's referenced by 1-d coordinate.
  // Note again that the 1-d order of squares is left-to-right, top-to-bottom.
  public func click1d(index: Int) -> GameStatus {
    if index < 0 || index >= squareCount { return GameStatus(gameState) }
    
    return clickSquare(squares[index])
  }
  
  // ClickSquare is called from either the 1-d or 2-d method above
  // when the user clicks a square.
  // - Get an array of all changed MapSquares from the target square's Click() method
  // - Transform that array into an array of GameSquares and return it
  // - Return an empty array if no squares are changed (e.g. user clicks on an already-clicked square)
  // - Return all squares with mines, if the user clicks on a mine
  func clickSquare(square: MineSquare!) -> GameStatus {
    
    if square == nil { return GameStatus(gameState) }
    
    // Set gameState to Ongoing if this is the first click.
    if gameState == .Unstarted { gameState = .Ongoing }
    
    // GameSquare.click() returns all squares changed as a result of the click.
    let result = square.click().toGameSquares()
    
    // This next block will only fire if the user clicked on a mine.
    // In that case, lose, register a finish, and return the mines.
    if result.count == 1 && result[0].hasMine {
      gameState = .Lost
      registerFinish()
      let mines = squares.filter({ $0.hasMine })
      
      for mine in mines {
        mine.click()
      }
      
      return GameStatus(withState: gameState, withSquares: mines.toGameSquares())
    }
    
    // And finally we want to do a quick test to see if the game is over.
    // If the game has ended, return all squares for completeness's sake.
    if testForWin() {
      return GameStatus(withState: gameState, withSquares: squares.toGameSquares())
    }
    
    return GameStatus(withState: gameState, withSquares: result)
  }
  
  // Return true if the user has revealed every non-mine square.  Else false.
  // We know we've won if every non-mine square's IsVisible property was set to true (by either Click or NeighborClick)
  func testForWin() -> Bool {
    // See if any squares exist that are hidden without a mine.
    // We could use a filter(:) op here but since we don't need the whole collection back, just iterate.
    for square in squares {
      if !square.isVisible && !square.hasMine {
        return false
      }
    }
    
    // OK - to get to here we have to be in a "won the game" state.
    // Register that and return true.
    gameState = .Won
    registerFinish()
    return true
  }
  
  // just tell each square that the game is over, and how, and let them update themselves.
  func registerFinish() {
    for square in squares {
      square.registerFinish(gameState)
    }
  }
  
  // MARK: - Helper methods
  
  // Return the square at x, y.  Return nil for invalid coordinates.
  func squareAt(x: Int, _ y: Int) -> MineSquare? {
    let index = indexOf(x, y)
    if index < 0 {
      return nil;
    }
    
    return squares[index]
  }
  
  // Return the 1-D index of the coordinates x, y
  // Return -1 for any invalid coordinates
  func indexOf(x: Int, _ y: Int) -> Int {
    if x < 0 || x >= width || y < 0 || y >= height {
      return -1;
    }
    
    // the 1-d array is constructed left-to-right, top-to-bottom.
    return y * width + x;
  }
  
  // Return the x, y coordinates of a given 1-D index
  // Return -1, -1 for any invalid index
  func coordinatesOfIndex(index: Int) -> (x: Int, y: Int) {
    if index < 0 || index > squareCount {
      return (-1, -1)
    }
    
    let y = index / width
    let x = index % width
    
    return (x, y)
  }
}

// Convert an array of MineSquares to an array of GameSquares.
extension CollectionType where Generator.Element: MineSquare {
  func toGameSquares() -> [GameSquare] {
    return self.map({ return GameSquare($0) })
  }
}

