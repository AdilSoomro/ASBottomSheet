//
//  ASBottomSheetItem.swift
//  Imagitor
//
//  Created by Adil Soomro on 3/13/17.
//  Copyright © 2017 BooleanBites Ltd. All rights reserved.
//

import UIKit
public typealias ActionSuccess = () -> ();
@objc open class ASBottomSheetItem: NSObject {
    var title:String? = nil
    var icon:UIImage? = nil
    private var tintedIcon:UIImage? = nil
    
    
    @objc open var action: ActionSuccess? = nil
    
    @objc public init(withTitle title:String, withIcon icon:UIImage) {
        super.init()
        
        self.title = title
        self.icon = icon
        
    }
    
    /**
     *  Makes a tinted image
     *  - parameter color: the tint color
     *  - returns: a tinted image
     */
    func tintedImage(withColor color:UIColor?) -> UIImage? {
        //cache the previous icon, and don't make new one
        if self.tintedIcon != nil {
            return tintedIcon
        }
        
        guard icon != nil else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions (icon!.size, false, UIScreen.main.scale);
        
        let context:CGContext  = UIGraphicsGetCurrentContext()!;
        let rect:CGRect = CGRect(x:0,y: 0, width:icon!.size.width, height:icon!.size.height);
        
        //resolve CG/iOS coordinate mismatch
        context.scaleBy(x: 1, y: -1);
        context.translateBy(x: 0, y: -rect.size.height);
        
        //set the clipping area to the image
        context.clip(to: rect, mask: icon!.cgImage!);
        
        //set the fill color
        context.setFillColor((color?.cgColor.components!)!);
        context.fill(rect);
        
        //blend mode overlay
        context.setBlendMode(.overlay);
        
        //draw the image
        context.draw(icon!.cgImage!, in: rect)
        
        
        self.tintedIcon  = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return tintedIcon
        
    }
}
