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
    
    var gameSquare: GameSquare?


    func renderGameSquare(square: GameSquare) {
        self.gameSquare = square;

        self.setTitle(String(format: "%d, %d", square.x, square.y), forState: .Normal)
        
        if square.IsFlagged {
            // draw a grey rectangle with a black border with a flag
        }
        else if square.NeighborMineCount < 0 {
            // draw a grey rectangle with a black border
        }
        else if square.NeighborMineCount == 0 {
            // draw a white rectangle with no border
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
