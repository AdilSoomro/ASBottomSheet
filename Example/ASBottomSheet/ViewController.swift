//
//  ViewController.swift
//  ASBottomSheet
//
//  Created by AdilSoomro on 03/18/2017.
//  Copyright (c) 2017 AdilSoomro. All rights reserved.
//

import UIKit
import ASBottomSheet
class ViewController: UIViewController {
    var bottomSheet: ASBottomSheet!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let first = ASBottomSheetItem(withTitle: "Add Image", withIcon: UIImage.init(named: "image_icon")!)
        let second = ASBottomSheetItem(withTitle: "Add Sticker", withIcon: UIImage.init(named: "sticker_icon")!)
        let third = ASBottomSheetItem(withTitle: "Add Image", withIcon: UIImage.init(named: "image_icon")!)
        
        bottomSheet = ASBottomSheet.menu(withOptions: [first, second, third])
        
        UIToolbar.appearance().barTintColor = UIColor.darkGray
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showMenu(_ sender: Any) {
        self.bottomSheet.showMenu(fromViewController: self)
    }
}

