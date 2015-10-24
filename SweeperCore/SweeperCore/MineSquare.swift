//
//  MineSquare.swift
//  Sweeper
//
//  Created by Michael Chaffee on 9/24/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

import Foundation

// A MineSquare is one square of a Minesweeper board.
// The class contains all properties and methods to manage its own state.
// All methods which (may) change object state will return changed object(s).

class MineSquare {
  //MARK: - Properties
  let x: Int; // x index in the board.
  let y: Int; // y index in the board.
  let index: Int; // 1-d index in the board (l-to-r, top-to-bottom)
  var hasMine = false; // True if there's a mine on this square
  var isFlagged = false;  // True if the user has planted a flag on this mine
  var isVisible = false;  // True if this square should show its state (neighbor mine count)
  var isClicked = false;  // True if the user has clicked on this square (i.e. True means show the neighbor count)
  var neighbors = [MineSquare](); // Pointers to the mine's <=8 neighbors
  var neighborMineCount = 0;  // Number of neighbor squares containing mines.  This will be built at the same time as the Neighbors array.
  
  //MARK: - Initializers
  init(atX: Int, atY: Int, atIndex: Int) {
    self.x = atX;
    self.y = atY;
    self.index = atIndex;
  }
  
  // A MineBoard calls this to add one neighbor to the Neighbors property, incrementing NeighborMineCount if appropriate.
  // Accept nils gracefully.
  func AddNeighbor(neighbor: MineSquare!) {
    if neighbor != nil {
      neighbors.append(neighbor)
      neighborMineCount += (neighbor.hasMine ? 1 : 0)
    }
  }
  
  // Call this when the user clicks the square.
  // 1) Set self.IsClicked to True
  // 2) If the click trips a mine, return only this square.  The Board will interpret that as a bust and return all mines.
  // 3) If the click doesn't trip a mine, call NeighborClicked() on Self and each neighbor
  // 4) Return an array of all changed squares (can be 0 if no changes happened)
  func click() -> [MineSquare]{
    var result = [MineSquare]()
    
    if !isClicked {
      isClicked = true
      
      // Return only this square if we just tripped a mine.  That's the signal to the Board that we have a problem.
      if hasMine {
        result.append(self)
        return result
      }
      result = self.neighborClicked()
    }
    
    return result
  }
  
  // Call this when the user plants a flag in this square.
  // If the object's state changes, return the object; else nil.
  func flag() -> MineSquare? {
    var result: MineSquare? = nil;
    
    if !isFlagged {
      isFlagged = true
      result = self
    }
    
    return result
  }
  
  // Pass in end-of-game results here.
  func registerFinish(state: GameState) {
    if state == .Won {
      isVisible = true;
      isClicked = true;
    }
  }
  
  // Call this when a neighbor to this square was clicked.  (also called on the square that was clicked, if it doesn't contain a mine)
  // 1) Bail out if this method has already been called on this square
  // 2) Set Self.IsVisible to True if !self.IsVisible and !self.IsFlagged (flagged cells don't halt propagation but also don't show themselves)
  // 3) If Self.NeighborMineCount == 0, then call this on all the neighbors.
  // 4) Return all (potentially 0) squares with changes.
  func neighborClicked() -> [MineSquare] {
    var result = [MineSquare]()
    
    if !isVisible {
      if !isFlagged {
        isVisible = true
        result.append(self)
      }
      
      if neighborMineCount == 0 {
        for neighbor in neighbors.filter( {!$0.isVisible}) {
          result += neighbor.neighborClicked()
        }
      }
    }
    
    return result
  }
}