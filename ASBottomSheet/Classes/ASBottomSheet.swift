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

open class ASBottomSheet: UIViewController{
    var menuItems:[ASBottomSheetItem]? = nil
    
    @IBOutlet var collectionView: UICollectionView!
    public var tintColor:UIColor?
    public var isOpen = false
    /**
     *  Makes a `ASBottomSheet` that can be shown from bottom of screen.
     *  - parameter array: the options to be shown in menu collection view
     */
    open static func menu(withOptions array:[ASBottomSheetItem]) -> ASBottomSheet?{
        
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
        
        
    }
    
    /**
     *  Shows the menu from bottom of the provided view controller
     *  - parameter viewController: the host view controller
     */
    open func showMenu(fromViewController viewController:UIViewController) {
        let view = self.view // force to load the view
        let viewHeight = self.calculateHeight()
        
        let hostFrame:CGRect = viewController.view.bounds
        
        var frame = CGRect(x:0, y:hostFrame.size.height + viewHeight, width:hostFrame.width ,height:viewHeight)
        
        viewController.addChildViewController(self)
        viewController.view.addSubview(view!)
        self.didMove(toParentViewController: viewController)
        
        view?.frame = frame
        
        frame.origin.y = hostFrame.size.height - viewHeight;
        frame.size.height = viewHeight;
        view?.backgroundColor = UIColor.clear
        isOpen = true
        
        //since we've the proper frame to view now, we can center the items.
        centerTheContent(withWidth: frame.width)
        
        UIView.animate(withDuration: 0.2) {
            view?.frame = frame;
        }
    }
    func centerTheContent(withWidth frameWidth:CGFloat) {
        var insets = self.collectionView.contentInset
        insets.left = 0
        self.collectionView.contentInset =  insets
        
        let collectionViewWidth = (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width
        var leftInsets = ((frameWidth - (collectionViewWidth * CGFloat(menuItems!.count))) * 0.5) - (CGFloat(menuItems!.count-1) * 5)
        if leftInsets <= 0 {
            leftInsets = 0
        }
        insets.left = leftInsets
        self.collectionView.contentInset =  insets
    }
    /**
     *  Hides the bottom menu with animation.
     *
     */
    open func hide() {
        //first take the menu frame and set its y origin to its bottom by adding
        //its current origin plus height
        var frame = self.view.frame;
        frame.origin.y = frame.origin.y + frame.size.height;
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame = frame;
        }) { (finished:Bool) in
            
            //cleanup
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            self.isOpen = false
        };
        
    }
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            let parentFrame = self.parent?.view.bounds;
            var frame = self.view.frame;
            frame.size.width = (parentFrame?.size.width)!
            self.view.frame = frame;
            self.centerTheContent(withWidth: frame.size.width)
            
            let viewHeight = self.calculateHeight()
            frame.size.height = viewHeight;
            frame.origin.y = (parentFrame?.size.height)! - viewHeight;
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame = frame;
            }) { (finished:Bool) in
                self.centerTheContent(withWidth: frame.size.width)
                self.collectionView.reloadData()
                
            };
        }) { (UIViewControllerTransitionCoordinatorContext) in
            
        }
        
        super.viewWillTransition(to: size, with: coordinator)
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
        
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menuItem: ASBottomSheetItem = menuItems![indexPath.row]
        hide()
        if menuItem.action != nil {
            menuItem.action!()
        }
    }
    
    /**
     *  Calculates and returns the height to be consumed by the menu
     *  - return menu height
     *
     */
    func calculateHeight() -> CGFloat {
        let topPadding:CGFloat = 40.0; //40 is top padding of collection view.
        
        let bottomPadding:CGFloat = 10.0 // 10 is bottom padding of collection view.
        
        return topPadding + collectionView.collectionViewLayout.collectionViewContentSize.height + bottomPadding
    }
    

    
    
}

