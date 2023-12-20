//
//  DCImageCompressTool.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/5.
//

import UIKit

public typealias DCImage = (image:UIImage, base64:String, data:Data)

public class DCImageCompressTool: NSObject {

    public static func f_imageCompressed(_ image: UIImage) -> DCImage? {
        let targetSize = f_getTargetSize(originalSize: image.size)
        if targetSize == CGSize.zero {
            return nil
        }
        var modifiedImage = image
        if targetSize != image.size {
            modifiedImage = f_imageByModifieSize(image, targetSize)!
        }
        var data = modifiedImage.jpegData(compressionQuality: 1.0)!
        var size = CGFloat(data.count) / 1024.0 / 1024.0 // kb  mb
        let kbSize = CGFloat(data.count) / 1024.0
        if kbSize < 800 {
            let base64Str = data.base64EncodedString()
            let compressedImage = UIImage(data: data)!
            return (compressedImage,base64Str,data)
        }
        
        if size > 10 && size < 20{
            modifiedImage = f_imageByModifieSize(image, .init(width: image.size.width/2, height: image.size.height/2))!
        }else if size >= 20 {
            modifiedImage = f_imageByModifieSize(image, .init(width: image.size.width/4, height: image.size.height/4))!
        }
        data = modifiedImage.jpegData(compressionQuality: f_compressMultipleWithOriginalSize(size))!
        size = CGFloat(data.count) / 1024.0 / 1024.0 // kb  mb
        let base64Str = data.base64EncodedString()
        let compressedImage = UIImage(data: data)!
        return (compressedImage,base64Str,data)
    }
    
    private static func f_compressMultipleWithOriginalSize(_ size: CGFloat) -> CGFloat {
        if size < 0.9 {
            return 1
        }
        return 0.9 / size
    }
    private static func f_imageByModifieSize(_ image: UIImage, _ targetSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1)
        image.draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    private static func f_getTargetSize(originalSize: CGSize) -> CGSize {
        let imageW = originalSize.width
        let imageH = originalSize.height
        var targetImageW = imageW
        var targetImageH = imageH
        let allowMin: CGFloat = 256.0
        let allowMax: CGFloat = 4096.0
        var targetSize = CGSize.zero
        let mina = min(imageW, imageH)
        let maxa = max(imageW, imageH)
        if mina >= allowMin && maxa <= allowMax {
            return originalSize
        }
        if mina < allowMin {
            if imageW <= imageH {
                targetImageW = allowMin
                targetImageH = imageH / imageW * targetImageW
            } else {
                targetImageH = allowMin
                targetImageW = imageW / imageH * targetImageH
            }
        } else if maxa > allowMax {
            if imageW >= imageH {
                targetImageW = allowMax
                targetImageH = imageH / imageW * targetImageW
            } else {
                targetImageH = allowMax
                targetImageW = imageW / imageH * targetImageH
            }
        }
        if min(targetImageW, targetImageH) < allowMin || max(targetImageW, targetImageH) > allowMax {
            return CGSize.zero
        }
        targetSize = CGSize(width: targetImageW, height: targetImageH)
        return targetSize
    }
    
    
}
