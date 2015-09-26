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
    
    @IBOutlet weak var mineButton: MineSquareButton!
    
    func RenderGameSquare(square: GameSquare) {
        mineButton.renderGameSquare(square)
    }
}
