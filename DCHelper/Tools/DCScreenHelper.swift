//
//  DCScreenHelper.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/11/29.
//

import Foundation
import UIKit
public class DCScreenHelper {
    
    public static let mainScreenWidth = UIScreen.main.bounds.size.width

    public static func navigationBarHeight() -> CGFloat {
        return 44.0
    }

    public static func statusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }

    public static func topBarHeight() -> CGFloat {
        return statusBarHeight() + navigationBarHeight()
    }

    public static func safeAreaBottomInset() -> CGFloat {
        if let window = UIApplication.shared.keyWindow {
            return window.safeAreaInsets.bottom
        }
        return scaleSize(20)
    }

    public static func convertWidthToMainScreenScale(_ value: CGFloat) -> CGFloat {
        return mainScreenWidth * value / 375.0
    }
    
    public static func tabbarHeight()->CGFloat{
        let contentHeight = scaleSize(49)
        return safeAreaBottomInset() + contentHeight
    }
}

public func scaleSize(_ size: CGFloat) -> CGFloat {
    return DCScreenHelper.convertWidthToMainScreenScale(size)
}
