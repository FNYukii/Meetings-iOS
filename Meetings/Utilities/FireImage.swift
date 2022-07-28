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
    
    static func uploadImage(image: UIImage, completion: ((String?) -> Void)?) {
        // Data to upload
        let data = image.pngData()!

        // Reference
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagePath = "images/\(UUID()).png"
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
    
}
