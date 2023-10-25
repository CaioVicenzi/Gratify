//
//  SwiftUIView.swift
//  Gratify
//
//  Created by Caio Marques on 24/05/23.
// 

import SwiftUI

// SHARE SHEET, QUE PERMITE COM QUE O USUÁRIO CONSIGA COMPARTILHAR ELEMENTOS 
struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}

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

// retorna uma string que representa a data formatada para o padrão brasileiro (sem tempo em horas/minutos)
func formatarDataParaBrasileira(date: Date) -> String {
    let dateFormatter = DateFormatter()
    
    dateFormatter.locale = Locale(identifier: "pt_BR")
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    
    return dateFormatter.string(from: date)
}
