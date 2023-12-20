//
//  DCToastHelper.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/4.
//

import UIKit
import MBProgressHUD
public final class DCToastHelper: NSObject {
    
    public static let shared = DCToastHelper()
    
    private var hud: MBProgressHUD?
    
}
extension DCToastHelper{
    
    public func showLoading(to view:UIView){
        self.hide()
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.mode = .indeterminate
            self.hud = hud
        }
    }
    
    public func showMessage(_ message:String,view:UIView){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.minSize = CGSize(width:140, height: 60)
        hud.isUserInteractionEnabled = false
        hud.label.text = message
        hud.label.textColor = UIColor.white
        hud.label.font = UIFont.systemFont(ofSize: 14)
        hud.label.numberOfLines = 0
        hud.bezelView.color = UIColor.black
        hud.bezelView.style = .solidColor
        hud.hide(animated: true, afterDelay: 3)
    }
    
    public func hide(){
        DispatchQueue.main.async {
            self.hud?.hide(animated: true)
        }
    }
}

