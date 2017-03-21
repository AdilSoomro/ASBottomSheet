//
//  ASBottomSheetCell.swift
//  Imagitor
//
//  Created by Adil Soomro on 3/13/17.
//  Copyright © 2017 BooleanBites Ltd. All rights reserved.
//

import UIKit

class ASBottomSheetCell: UICollectionViewCell {
    
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemTitleLabel: UILabel!
    override func awakeFromNib() {
        itemImageView.layer.cornerRadius = itemImageView.frame.width/2
        itemImageView.layer.borderWidth = 0.5
        itemImageView.layer.borderColor = UIColor.white.cgColor
    }
}
