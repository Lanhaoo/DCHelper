//
//  DCNSAttributedString.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/11/29.
//

import Foundation
import UIKit
public extension NSAttributedString {
    func addUnderline() -> NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else { return self }
        let range = (self.string as NSString).range(of: self.string)
        copy.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: range)
        return copy
    }
}
