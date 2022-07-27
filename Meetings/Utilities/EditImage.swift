//
//  EditImage.swift
//  Meetings
//
//  Created by Yu on 2022/07/28.
//

import UIKit
import Foundation

class EditImage {
    
    static func resizeImage(image: UIImage, width: Double) -> UIImage {
        // アスペクト比を取得
        let aspectRatio = image.size.height / image.size.width
        
        // リサイズ後のCGSizeを決める
        let resizedSize = CGSize(width: width, height: width * Double(aspectRatio))
        
        // リサイズ
        UIGraphicsBeginImageContext(resizedSize)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
    
    static func clipImageToSquare(image: UIImage) -> UIImage {
        // 正方形の辺の長さを決める
        var oneSide: CGFloat = 0
        if image.size.width < image.size.height {
            oneSide = image.size.width
        } else {
            oneSide = image.size.height
        }
        
        // 切り取りの基準となる座標を決める
        var origin: CGPoint = CGPoint()
        if image.size.width < image.size.height {
            origin = CGPoint(x: 0.0, y: (image.size.width - image.size.height) * 0.5)
        } else {
            origin = CGPoint(x: (image.size.height - image.size.width) * 0.5, y: 0.0)
        }
        
        // 切り取り実行
        UIGraphicsBeginImageContextWithOptions(CGSize(width: oneSide, height: oneSide), false, 0.0)
        image.draw(in: CGRect(origin: origin, size: CGSize(width: image.size.width, height: image.size.height)))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
