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
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
            .environment(\.managedObjectContext, gratidaoController.container.viewContext)
            .onAppear {
                gratidaoController.update(context: gratidaoController.container.viewContext)
            }
        }
    }
}
