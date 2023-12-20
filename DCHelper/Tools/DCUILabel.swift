//
//  DCUILabel.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/11/29.
//

import Foundation
import UIKit
public extension UILabel{
    
    convenience init(font:UIFont,textColor:String,_ text:String = "") {
        self.init()
        self.font = font
        self.textColor = UIColor.init(hexString: textColor)
        self.text = text
    }
    
    convenience init(semiboldFontSize:CGFloat,textColor:String,_ text:String = "") {
        self.init(font: UIFont.systemFont(ofSize: scaleSize(semiboldFontSize), weight: .semibold), textColor: textColor, text)
    }
    
    convenience init(mediumFontSize:CGFloat,textColor:String,_ text:String = "") {
        self.init(font: UIFont.systemFont(ofSize: scaleSize(mediumFontSize), weight: .medium), textColor: textColor, text)
    }
    
    convenience init(regularFontSize:CGFloat,textColor:String,_ text:String = "") {
        self.init(font: UIFont.systemFont(ofSize: scaleSize(regularFontSize)), textColor: textColor, text)
    }
    
}
