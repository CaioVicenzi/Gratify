//
//  GratidaoControllerAntiga.swift
//  StreakWidgetExtension
//
//  Created by Caio Marques on 09/06/24.
//

import Foundation
import CoreData

class GratidaoControllerAntiga : ObservableObject {
    let container : NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
}
