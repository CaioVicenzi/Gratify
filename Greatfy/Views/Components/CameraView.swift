//
//  CameraView.swift
//  Gratify
//
//  Created by Caio Marques on 08/06/24.
//

import Foundation
import SwiftUI

// CAMERA VIEW, QUE PERMITE QUE O USUÁRIO UTILIZE A CAMERA
struct CameraView: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var dataImage:Data?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.dataImage = uiImage.jpegData(compressionQuality: 1.0)
            }
    
            parent.isShown = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShown = false
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
