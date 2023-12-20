//
//  DCUIColor.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/11/29.
//

import Foundation
import UIKit
public extension UIColor{
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }else{
            self.init(white: 1.0, alpha: 1.0)
        }
    }
    
    func getImage() -> UIImage {
         let rect = CGRect.init(x: 0, y: 0, width: 1.0, height: 1.0)
         UIGraphicsBeginImageContext(rect.size)
         let context = UIGraphicsGetCurrentContext()

         context?.setFillColor(self.cgColor)
         context?.fill(rect)
         let image = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndPDFContext()
         return image!
    }
    
}
