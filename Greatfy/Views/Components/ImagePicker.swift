//
//  ImagePicker.swift
//  Gratify
//
//  Created by Caio Marques on 08/06/24.
//

import Foundation
import SwiftUI

// IMAGE PICKER PARA O REGISTRARIMAGEMVIEW
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isImagePickerPresented:Bool
    @Binding var imagemData:Data?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.imagemData = uiImage.jpegData(compressionQuality: 1.0)
            }

            parent.isImagePickerPresented = false
        }
    }
}
