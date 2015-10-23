//
//  MineSquareCell.swift
//  Sweeper
//
//  Created by Michael Chaffee on 9/26/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

import UIKit
import SweeperCore

// The MineSquareCell contains a MineSquareButton, which is the object that does all the rendering work.
class MineSquareCell: UICollectionViewCell {
  
  private var viewController: SweeperGridViewController!
  private var index = -1
  
  @IBOutlet weak var mineButton: MineSquareButton!
  
  // Pass the button press back to the view controller.
  @IBAction func mineButton_TouchUpInside(sender: MineSquareButton) {
    if self.viewController == nil || self.index < 0 { return }
    
    self.viewController.squareClicked(atIndex: self.index)
  }
  
  func Attach(toViewController controller: SweeperGridViewController, atIndex: Int) {
    self.viewController = controller;
    self.index = atIndex
  }
  
  func RenderGameSquare(square: GameSquare, forGameState state: GameState) {
    mineButton.renderGameSquare(square, forGameState: state)
  }
}
