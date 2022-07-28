//
//  ImagesPickerView.swift
//  Meetings
//
//  Created by Yu on 2022/07/28.
//

import SwiftUI
import PhotosUI

struct ImagesPickerView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var images: [UIImage]
    @Binding var isPicking: Bool
    
    class Coordinator: NSObject, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
        let parent: ImagesPickerView
        
        init(_ parent: ImagesPickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            // 1枚も選択しなかったのなら終了
            if results.count == 0 {
                return
            }
            
            parent.isPicking = true
            
            // imagesを一度空にする
            self.parent.images = []
            
            // resultsの要素数だけループ
            results.forEach { result in
                // resultから画像をロード
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                    // エラーなら終了
                    guard let image = image as? UIImage else {
                        self?.parent.isPicking = false
                        return
                    }
                    // 画像を配列に追加
                    DispatchQueue.main.sync {
                        let resizedImage = EditImage.resizeImage(image: image, width: 1000)
                        self?.parent.images.append(resizedImage)
                        self?.parent.isPicking = false
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagesPickerView>) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 4
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<ImagesPickerView>) {
        // Do nothing
    }
}

