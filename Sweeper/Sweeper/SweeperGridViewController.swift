//
//  SweeperGridViewController.swift
//  Sweeper
//
//  Created by Michael Chaffee on 9/26/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

import UIKit
import SweeperCore
import CoreFoundation

class SweeperGridViewController: UICollectionViewController {
    
    @IBAction func newButtonAction(sender: AnyObject) {
        loadNewBoard()
    }
    @IBOutlet var gridView: UICollectionView!
    
    // MARK: Private Properties
    
    private let reuseIdentifier = "MineSquareCell"
    
    // We set the squareSize value here, and impose it via the sizeForItemAtIndexPath operation below.
    // That's so we have an authoritative size value when we calculate the size of the game board in squares.
    private let squareSize = CGSize(width: 50, height: 50)
    
    // mineBoard gets properly instantiated in LoadNewBoard()
    private var mineBoard = MineBoard(width:1, height:1, minePercent:0)
    private var squares = [GameSquare]()
    
    private var gameState = GameState.Unstarted
    
    // This function returns a GameSquare corresponding to the 1-d index of a given cell.
    // Traversal is left-to-right, top-to-bottom.
    private func gameSquareForIndexPath(indexPath: NSIndexPath) -> GameSquare {
        //        return mineBoard.SquareForIndex(indexPath.row)
        return squares[indexPath.row]
    }
    
    
    // MARK: - UIViewController operations
    
    // Load a new board when the view loads.
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.gameState == .Unstarted {
            self.loadNewBoard()
        }
    }
    // TODO:  Manage device rotation 
    // (accept rotation only upon new-board operation; but possibly rotate individual UI elements?)

    // MARK: - Custom Operations
    
    private func NewButtonClicked() {
        loadNewBoard()
    }
    
    // Load a new board.
    // TODO:  Offer difficulty options.
    private func loadNewBoard() {
        self.gameState = .Unstarted
        let gridSize = self.gridSize()
        
        mineBoard = MineBoard(width: gridSize.width, height: gridSize.height, minePercent: 0.1)
        squares = mineBoard.GameSquares
        
        self.collectionView?.reloadData()
    }
    
    // Calculate the grid size in squares.
    func gridSize() -> (width: Int, height: Int) {
        let bounds = self.view.bounds
        let x = bounds.width / squareSize.width
        let y = bounds.height / squareSize.height
        
        return (width: Int(x), height: Int(y))
    }
    
    // Respond to a user click on a square.
    func squareClicked(atIndex index: Int) {
        if self.gameState == .Won || self.gameState == .Lost { return }
        processChanges(mineBoard.Click1d(index))
    }
    
    // Receive a list of changed cells and (hopefully gracefully) change them in the CollectionView.
    func processChanges(changes: GameStatus) {
        self.gameState = changes.State
        
        // Disable animation during reload
        let animationsEnabled = UIView.areAnimationsEnabled()
        UIView.setAnimationsEnabled(false)
        defer { UIView.setAnimationsEnabled(animationsEnabled) }
        
        let changeCount = changes.Squares.count
        // Store the received changes locally.
        var indexPaths = [NSIndexPath](count: changes.Squares.count, repeatedValue: NSIndexPath(forRow: 0, inSection: 0))
        for var i = 0; i < changeCount; i++ {
            let square = changes.Squares[i]
            squares[square.index] = square
            indexPaths[i] = NSIndexPath(forRow: square.index, inSection: 0)
        }
        
        // Now we have to decide how to update the view.  reloadItemsAtIndexPaths() gets super slow for large
        // counts, but is faster for small counts.  Meanwhile, reloadData() is fast and good, but causes a nasty
        // flicker as items load out of order...
//        if changeCount > 20 {
//            self.collectionView?.reloadSections(NSIndexSet(index: 0))
//        }
//        else {
            self.collectionView?.reloadItemsAtIndexPaths(indexPaths)
//        }
    }
    
    // MARK: - Basic CollectionView operations
    
    // Force number of sections to 1.
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Get item count.
    // The number of items is necessarily the board's square count.
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return squares.count
    }
    
    // This is the data-binding operation.  When cellForItemAtIndexPath is called:
    // - Get the square for that location from the MineBoard
    // - Tell the cell to render that square
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MineSquareCell
        
        cell.Attach(toViewController: self, atIndex: indexPath.row)
        
        let gameSquare = gameSquareForIndexPath(indexPath)
        
        cell.RenderGameSquare(gameSquare, forGameState: self.gameState)
        
        return cell
    }
    
    // We're setting the square size programmatically so that this class's squareSize property is authoritative (since it's also needed to calculate the x/y size of the board)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize    {
        return squareSize;
    }
    
}


