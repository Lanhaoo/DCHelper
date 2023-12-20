//
//  DCUIViewController.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/11/29.
//

import Foundation

public let KycComplectedNotification = Notification.Name(rawValue: "KycComplectedNotification")

public let OrderWaitingForCommitNotification = Notification.Name(rawValue: "OrderWaitingForCommitNotification")

public let OrderWaitingForPaymentNotification = Notification.Name(rawValue: "OrderWaitingForPaymentNotification")

public extension UIViewController{
    
    func addNotificationObserver(_ name: String, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
    }
    

    func removeNotificationObserver(_ name: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: name), object: nil)
    }
    

    func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func push(_ viewController:UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popToRootViewController() {
        navigationController?.popToRootViewController(animated: true)
    }

    func popViewController(){
        navigationController?.popViewController(animated: true)
    }
    
    func showSystemPermissionDeniedAlert(message: String, confirmBlock: (() -> Void)? = nil, cancelBlock: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Consejos del sistema", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ir a la configuración", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            confirmBlock?()
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { _ in
            cancelBlock?()
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
