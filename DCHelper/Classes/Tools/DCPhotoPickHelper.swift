//
//  DCPhotoPickHelper.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/6.
//

import UIKit

public final class DCPhotoPickHelper: NSObject,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    public static let shared = DCPhotoPickHelper()
    
    private var isSelect = false
    
    private var pickPictureDoneBlock:((UIImage)->())?
    
    public func pickPicture(vc:UIViewController,closure:@escaping ((UIImage)->())) {
        DispatchQueue.main.async {
            self.isSelect = false
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            vc.present(imagePicker, animated: true, completion: nil)
            self.pickPictureDoneBlock = closure
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            if self.isSelect {
                return
            }
            self.isSelect = true
            if let pickedImage = info[.originalImage] as? UIImage {
                self.pickPictureDoneBlock?(pickedImage)
            }
            picker.dismiss(animated: true,completion: nil)
        }
    }
    
}
