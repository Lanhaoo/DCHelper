//
//  DCUIView.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/11/29.
//

import Foundation
import UIKit
public extension UIView{
    
    func layerCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    static func viewFromNib(_ nibName: String) -> Self? {
        let nib = UINib(nibName: nibName, bundle: nil)
        let views = nib.instantiate(withOwner: nil, options: nil)
        if let view = views.first as? Self {
            return view
        }
        return nil
    }
        
    func addTap(action: (() -> Void)?) {
        let tap = DCTapGestureRecognizer(tapAction: action)
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
}
