//
//  ImagePickerView.swift
//  Meetings
//
//  Created by Yu on 2022/07/28.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
        let parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            let itemProvider = results.first?.itemProvider
            
            if let itemProvider = itemProvider {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                    // 失敗
                    guard let image = image as? UIImage else {
                        return
                    }
                    
                    // 成功
                    DispatchQueue.main.sync {
                        let clipedImage = EditImage.clipImageToSquare(image: image)
                        let resizedImage = EditImage.resizeImage(image: clipedImage, width: 1000)
                        self?.parent.image = resizedImage
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<ImagePickerView>) {
        // Do nothing
    }
}
