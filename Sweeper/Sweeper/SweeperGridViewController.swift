//
//  SweeperGridViewController.swift
//  Sweeper
//
//  Created by Michael Chaffee on 9/26/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

import UIKit
import SweeperCore

class SweeperGridViewController: UICollectionViewController {

    @IBOutlet weak var NewButton: UIBarButtonItem!
    // MARK: Private Properties
    
    private let reuseIdentifier = "UIMineSquare"

    // We set the squareSize value here, and impose it via the sizeForItemAtIndexPath operation below.  
    // That's so we have an authoritative size value when we calculate the size of the game board in squares.
    private let squareSize = CGSize(width: 50, height: 50)
    
    // mineBoard gets properly instantiated in LoadNewBoard()
    private var mineBoard = MineBoard(width:1, height:1, minePercent:0)
    
    // This function returns a GameSquare corresponding to the 1-d index of a given cell.
    // Traversal is left-to-right, top-to-bottom.
    private func gameSquareForIndexPath(indexPath: NSIndexPath) -> GameSquare {
        return mineBoard.SquareForIndex(indexPath.row)
    }

    
    // MARK: - UIViewController operations
    
    // Load a new board when the view loads.
    override func viewDidLoad() {

        setUpToolbar()
        
        loadNewBoard()
        
        super.viewDidLoad()
    }

    private func setUpToolbar() {
//        let sel = Selector("NewButtonClicked")
//        NewButton.action = sel
    }
    
    // MARK: - Custom Operations

    private func NewButtonClicked() {
        loadNewBoard()
    }
    
    // Load a new board.
    private func loadNewBoard() {
        let gridSize = self.gridSize()
        
        mineBoard = MineBoard(width: gridSize.width, height: gridSize.height, minePercent: 0.1)
    }
    
    // Calculate the grid size in squares.
    func gridSize() -> (width: Int, height: Int) {
        let bounds = self.view.bounds
        let x = bounds.width / squareSize.width
        let y = bounds.height / squareSize.height
        return (width: Int(x), height: Int(y))
    }
    
    func squareClicked(atIndex index: Int) {
        mineBoard.Click1d(index)

        // TODO:  Make the flicker thing really go away
        let animationsEnabled = UIView.areAnimationsEnabled()
        UIView.setAnimationsEnabled(false)
        self.collectionView?.reloadData()
        UIView.setAnimationsEnabled(animationsEnabled)
    }

    // MARK: - Basic CollectionView operations
    
    // Force number of sections to 1.
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Get item count.
    // The number of items is necessarily the board's square count.
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mineBoard.SquareCount
    }

    // This is the data-binding operation.  When cellForItemAtIndexPath is called:
    // - Get the square for that location from the MineBoard
    // - Tell the cell to render that square
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MineSquareCell
        
        cell.Attach(toViewController: self, atIndex: indexPath.row)
        
        let gameSquare = gameSquareForIndexPath(indexPath)

        cell.RenderGameSquare(gameSquare)
        
        // Configure the cell
        return cell
    }
    
    // We're setting the square size programmatically so that this class's squareSize property is authoritative (since it's also needed to calculate the x/y size of the board)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize    {
        return squareSize;
    }

}


