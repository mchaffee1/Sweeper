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
    public let NeighborMineCount: Int
    public let IsFlagged: Bool
    public let HasMine: Bool
    
    init(_ square: MineSquare) {
        x = square.x;
        y = square.y;
        NeighborMineCount = (square.IsVisible ? square.NeighborMineCount : -1)
        IsFlagged = square.IsFlagged
        HasMine = square.IsClicked ? square.HasMine : false
    }
}