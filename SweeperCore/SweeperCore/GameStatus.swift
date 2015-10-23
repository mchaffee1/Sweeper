//
//  GameSquare.swift
//  Sweeper
//
//  Created by Michael Chaffee on 9/24/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

import Foundation

// The GameSquare struct is an external value representation of a MineSquare object.
// As such it contains NO information that the player can inspect or modify to their advantage.
public struct GameSquare {
  public let x: Int
  public let y: Int
  public let index: Int
  public let neighborMineCount: Int
  public let isFlagged: Bool
  public let hasMine: Bool
  
  init(_ square: MineSquare) {
    self.x = square.x;
    self.y = square.y;
    self.index = square.index;
    self.neighborMineCount = (square.isVisible ? square.neighborMineCount : -1)
    self.isFlagged = square.isFlagged
    self.hasMine = square.isClicked ? square.hasMine : false
  }
}

// Struct to contain the status of the game.
// Members currently are state and squares changed in last move.
public struct GameStatus {
  public let state: GameState
  public let squares: [GameSquare]
  
  public init(_ state: GameState)
  {
    self.init(withState: state, withSquares: [GameSquare]())
  }
  
  public init(withState state: GameState, withSquares squares: [GameSquare])
  {
    self.state = state;
    self.squares = squares;
  }
}

// Lis of possible states that the game could be in.
public enum GameState {
  case Unstarted
  case Ongoing
  case Won
  case Lost
}