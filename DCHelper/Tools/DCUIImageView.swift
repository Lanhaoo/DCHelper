//
//  DCUIImageView.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/11/29.
//

import Foundation
import UIKit
public extension UIImageView{
    
    convenience init(_ imageName:String) {
        self.init()
        let image = UIImage(named: imageName)
        self.image = image
    }
    
    func scaleAspectFill() {
        contentMode = .scaleAspectFill
        layer.masksToBounds = true
    }
    
}
