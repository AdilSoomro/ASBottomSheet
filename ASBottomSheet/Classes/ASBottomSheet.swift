//
//  ASBottomSheet.swift
//  Imagitor
//
//  Created by Adil Soomro on 3/13/17.
//  Copyright © 2017 BooleanBites Ltd. All rights reserved.
//

import UIKit

/**
 *  `ASBottomSheet` is a UIActionSheet like menu controller that can be used to
 *  show custom menu from bottom of the presenting view controller.
 *  It uses UICollectionView to show menu options provided by the developer.
 *  It is greatly inspired by the FCVerticalMenu
 */

@objc open class ASBottomSheet: UIViewController{
    var menuItems:[ASBottomSheetItem]? = nil
    
    @IBOutlet var collectionView: UICollectionView!
    public var tintColor:UIColor?
    
    private var bottomConstraints: NSLayoutConstraint!
    private var heigthConstraints: NSLayoutConstraint!
    @IBOutlet private var collectionViewLeadingConstraints: NSLayoutConstraint!
    @IBOutlet private var collectionViewTrailingConstraints: NSLayoutConstraint!
    @IBOutlet private var collectionViewBottomConstraints: NSLayoutConstraint!
    
    @objc public var isOpen = false
    
    /**
     *  Makes a `ASBottomSheet` that can be shown from bottom of screen.
     *  - parameter array: the options to be shown in menu collection view
     */
    @objc public static func menu(withOptions array:[ASBottomSheetItem]) -> ASBottomSheet?{
        
        let podBundle:Bundle? = Bundle(for:ASBottomSheet.classForCoder())
        let storyboard:UIStoryboard?
        //FROM COCOAPOD
        if let bundleURL = podBundle {
            
            storyboard = UIStoryboard.init(name: "ASBottomSheetStoryBoard", bundle: bundleURL)
            
            //FROM MANUAL INSTALL
        }else {
            storyboard = UIStoryboard.init(name: "ASBottomSheetStoryBoard", bundle: nil)
        }
        
        if let main = storyboard {
            let bottomMenu:ASBottomSheet = main.instantiateViewController(withIdentifier: "ASBottomSheet") as! ASBottomSheet
            
            bottomMenu.menuItems = array
            
            
            bottomMenu.tintColor = UIColor.white
            return bottomMenu
        }
        return nil
        
        
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        //        collectionView.backgroundColor = UIColor.orange
    }
    
    /**
     *  Shows the menu from bottom of the provided view controller
     *  - parameter viewController: the host view controller
     */
    @objc public func showMenu(fromViewController viewController:UIViewController) {
        
        if isOpen {
            return
        }
        
        let view = self.view // force to load the view
        let parentView = viewController.view // force to load the view
        self.collectionView.reloadData()
        
        
        
        viewController.addChild(self)
        viewController.view.addSubview(view!)
        self.didMove(toParent: viewController)
        
        //        view?.removeConstraints(view!.constraints)
        
        view?.translatesAutoresizingMaskIntoConstraints = false
        
        
        if #available(iOS 11.0, *) {
            let insets = parentView!.safeAreaInsets
            collectionViewTrailingConstraints.constant = 0 - insets.right
            collectionViewLeadingConstraints.constant = insets.left
        } else {
            let margins = parentView!.layoutMargins
            collectionViewTrailingConstraints.constant = 0 - margins.right
            collectionViewLeadingConstraints.constant = margins.left
        }
        
            NSLayoutConstraint.activate([
                view!.leadingAnchor.constraint(equalTo: parentView!.leadingAnchor),
                view!.trailingAnchor.constraint(equalTo: parentView!.trailingAnchor)
            ])
        
        
        var bottomPadding:CGFloat = 0.0
        if #available(iOS 11.0, *) {
            bottomPadding = viewController.view?.safeAreaInsets.bottom ?? 0.0
        }
        let viewHeight = (self.calculateHeight()) +  bottomPadding + 10.0
        
        bottomConstraints = NSLayoutConstraint(item: view!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: viewHeight)
        bottomConstraints.isActive = true
        
        
        collectionViewBottomConstraints.constant = 0 - bottomPadding - 10
        
        if heigthConstraints == nil {
            heigthConstraints = NSLayoutConstraint(item: view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: viewHeight)
            heigthConstraints.isActive = true
        } else {
            heigthConstraints.constant = viewHeight
        }
    
        
        
        
        
        parentView?.layoutIfNeeded()
        self.collectionView.reloadData()
        bottomConstraints.constant = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.setupHeight()
            parentView?.layoutIfNeeded()
        }) { (complettion) in
            
        }
        view?.backgroundColor = UIColor.clear
        isOpen = true
        
        
        
    }
    
    /**
     *  Hides the bottom menu with animation.
     *
     */
    @objc open func hide() {
        //first take the menu frame and set its y origin to its bottom by adding
        //its current origin plus height
        let frame = self.view.frame
        
        
        UIView.animate(withDuration: 0.2, animations: {
            self.bottomConstraints.constant = frame.origin.y + frame.size.height
            self.parent?.view.layoutIfNeeded()
        }) { (finished:Bool) in
            
            //cleanup
            
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
            self.didMove(toParent: nil)
            
            self.isOpen = false
        };
        
    }
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.collectionViewLayout.invalidateLayout()
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            
            self.setupHeight()
        }) { (UIViewControllerTransitionCoordinatorContext) in
            self.collectionView.reloadData()
            
        }
        
        
        
    }
    
    func setupHeight()  {
        var bottomPadding:CGFloat = 0.0
        if #available(iOS 11.0, *) {
            bottomPadding = self.parent!.view?.safeAreaInsets.bottom ?? 0.0
        }
        let viewHeight = (self.calculateHeight()) +  bottomPadding + 10.0
        heigthConstraints.constant = viewHeight
    }
    
}
extension ASBottomSheet : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (menuItems?.count)!
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ASBottomSheetCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASBottomSheetCell", for: indexPath) as! ASBottomSheetCell
        
        let menuItem: ASBottomSheetItem = menuItems![indexPath.row]
        
        cell.itemImageView.image = menuItem.tintedImage(withColor: self.tintColor)
        cell.itemTitleLabel.text = menuItem.title
        cell.itemTitleLabel.textColor = tintColor
        cell.itemImageView.tintColor = tintColor
        //        cell.backgroundColor = UIColor.red
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menuItem: ASBottomSheetItem = menuItems![indexPath.row]
        hide()
        if menuItem.action != nil {
            menuItem.action!()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
        
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let numberOfItems = CGFloat(collectionView.numberOfItems(inSection: section))
        let totalWidth = (numberOfItems * flowLayout.itemSize.width)
        if totalWidth > collectionView.frame.width {
            let numItemsInRow:CGFloat = CGFloat(Int(collectionView.frame.width / flowLayout.itemSize.width));
            let totalWidthForRow = flowLayout.itemSize.width * numItemsInRow
            
            let combinedWidthRow = totalWidthForRow  + ((numItemsInRow - 1)  * flowLayout.minimumInteritemSpacing)
            let paddingRow = (collectionView.frame.width - combinedWidthRow) / 2
            return UIEdgeInsets(top: 0, left: paddingRow, bottom: 0, right: paddingRow)
        }
        let combinedItemWidth = totalWidth + ((numberOfItems - 1)  * flowLayout.minimumInteritemSpacing)
        let padding = (collectionView.frame.width - combinedItemWidth) / 2
        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }
    /**
     *  Calculates and returns the height to be consumed by the menu
     *  - return menu height
     *
     */
    func calculateHeight() -> CGFloat {
        let topPadding:CGFloat = 10.0; //40 is top padding of collection view.
        
        let bottomPadding:CGFloat = 10.0 // 10 is bottom padding of collection view.
        
        return topPadding + collectionView.collectionViewLayout.collectionViewContentSize.height + bottomPadding
    }
    
    
    
    
}

