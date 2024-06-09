//
//  HapticHandler.swift
//  Gratify
//
//  Created by Caio Marques on 15/02/24.
//

import Foundation
import UIKit

class HapticHandler {
    static let instance = HapticHandler()
    
    func notificacao (tipo : UINotificationFeedbackGenerator.FeedbackType) {
        let gerador = UINotificationFeedbackGenerator()
        gerador.notificationOccurred(tipo)
        
    }
    
    func impacto (estilo : UIImpactFeedbackGenerator.FeedbackStyle) {
        let gerador = UIImpactFeedbackGenerator(style: estilo)
        gerador.impactOccurred()
    }
}
