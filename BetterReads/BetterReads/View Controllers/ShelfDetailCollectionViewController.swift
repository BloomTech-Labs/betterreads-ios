//
//  ShelfDetailCollectionViewController.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/6/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ShelfDetailCell"

class ShelfDetailCollectionViewController: UICollectionViewController {
    
    var tempShelfDetailCount: Int = 1
    // FIXME: change system color to trinidadOrange?
    @IBOutlet var addBookToShelfButtonLabel: UIBarButtonItem!
    
    @IBAction func addBookToShelfTapped(_ sender: UIBarButtonItem) {
        print("addBookToShelfTapped")
        tempShelfDetailCount += 1
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //ShelfToDetail
        if segue.identifier == "ShelfToDetail" {
            print("ShelfToDetail")
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return tempShelfDetailCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        // FIXME: downcast as ShelfDetailCollectionViewCell
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension ShelfDetailCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
    
    // MARK: Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 2
        
        let insets = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: 0)
        
        let horizontalInsets = insets.left + insets.right
        
        let itemSpacing = (self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: 0)) * (itemsPerRow - 1)
        
        let width = (collectionView.frame.width - horizontalInsets - itemSpacing) / itemsPerRow
        print("sizeForItemAt = \(CGSize(width: width, height: width * 1.3))")
        print("safeAreaLayoutGuide = \(self.view.safeAreaLayoutGuide)")
        return CGSize(width: width, height: width * 1.4)
    }
}
