//
//  FireImage.swift
//  Meetings
//
//  Created by Yu on 2022/07/28.
//

import Foundation
import UIKit
import FirebaseStorage

class FireImage {
    
    static func uploadImage(image: UIImage, folderName: String, completion: ((String?) -> Void)?) {
        // Data to upload
        let data = image.pngData()!

        // Reference
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagePath = "\(folderName)/\(UUID()).png"
        let imageRef = storageRef.child(imagePath)
        
        imageRef.putData(data, metadata: nil) { (metadata, error) in
            // 失敗
            if let error = error {
                print("HELLO! Fail! Error uploading image. \(error)")
                completion?(nil)
                return
            }
            
            // 成功
            // URLをダウンロード
            imageRef.downloadURL { (url, error) in
                // 失敗
                if let error = error {
                    print("HELLO! Fail! Error downloading URL. \(error)")
                    completion?(nil)
                    return
                }
                if url == nil {
                    print("HELLO! Fail! URL is nil.")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Uploaded 1 image.")
                let urlString = url!.absoluteString
                completion?(urlString)
            }
        }
    }
    
    static func uploadImages(images: [UIImage], folderName: String, completion: (([String]?) -> Void)?) {
        // imagesが空なら失敗
        if images.count == 0 {
            completion?([])
            return
        }
        
        // 画像をアップロードしていく
        var imageUrls: [String] = []
        var uploadCount = 0
        images.forEach { image in
            uploadImage(image: image, folderName: "images") { imageUrl in
                uploadCount += 1
                
                // 失敗
                if imageUrl == nil {
                    // 一枚でもアップロードに失敗したら、uploadImagesは失敗とする
                    completion?(nil)
                    return
                }
                
                // 成功
                // imageUrlを配列に追加していく
                imageUrls.append(imageUrl!)
                                
                // 画像を全てアップロードできたら、imagePaths配列をreturn
                if images.count == uploadCount {
                    completion?(imageUrls)
                }
            }
        }
    }
    
}
