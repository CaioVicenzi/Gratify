//
//  ShareSheet.swift
//  Gratify
//
//  Created by Caio Marques on 08/06/24.
//

import Foundation
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
