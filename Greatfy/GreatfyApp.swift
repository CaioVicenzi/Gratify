//
//  GreatfyApp.swift
//  Greatfy
//
//  Created by Caio Marques on 03/05/23.
//

import SwiftUI

@main
struct GreatfyApp: App {
    @StateObject private var gratidaoController = GratidaoController()
    @AppStorage ("alreadyUploaded") var alreadyUploaded = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if gratidaoController.semaforo {
                    if alreadyUploaded {
                        HomeView()
                    } else {
                        AlreadyUploadedView()
                    }
                } else {
                    ProgressView()
                }
            }
            .environment(\.managedObjectContext, gratidaoController.container.viewContext)
        }
    }
}
