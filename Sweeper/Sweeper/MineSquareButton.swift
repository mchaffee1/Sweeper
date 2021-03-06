//
//  UIMineSquare.swift
//  Sweeper
//
//  Created by Michael Chaffee on 9/24/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

import UIKit
import SweeperCore

// The MineSquareButton is the object within the CollectionView Cell for each square of the game.
// This object manages all the visual presentation of the underlying GameSquare's state.
class MineSquareButton  : UIButton {
  
  private let untouchedColor = UIColor(red:0.5, green:0.5, blue:0.5, alpha:0.5)
  private let touchedColor = UIColor.whiteColor()
  
  private let blueTint = UIColor.blueColor()
  private let redTint = UIColor.redColor()
  private let greenTint = UIColor.greenColor()
  
  var gameSquare: GameSquare?
  
  
  func renderGameSquare(square: GameSquare, forGameState state: GameState) {
    self.gameSquare = square;
    
    // These are the default attributes (for an untouched cell).  Modify if needed before it all sets up at the end.
    var title = ""
    var backgroundColor = untouchedColor
    var tintColor = blueTint
    defer {
      self.setTitle(title, forState: .Normal)
      self.backgroundColor = backgroundColor
      self.tintColor = tintColor
    }
    
    if square.isFlagged {
      // TODO: draw a grey rectangle with a black border with a flag
    }
    else if square.neighborMineCount >= 0 {
      backgroundColor = touchedColor
      if square.neighborMineCount > 0 {
        title = String(format: "%d", square.neighborMineCount)
      }
    }
    
    if square.hasMine {
      if state == .Won {
        title = "WIN"
        backgroundColor = greenTint
        tintColor = UIColor.whiteColor()
      }
      else {
        title = "BLAM"
        backgroundColor = touchedColor
        tintColor = redTint
      }
    }
  }
}