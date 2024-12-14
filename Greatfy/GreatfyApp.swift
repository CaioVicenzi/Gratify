//03/05/23

import SwiftUI

@main
struct GreatfyApp: App {
    @StateObject private var gratidaoController = GratidaoController()
    @AppStorage("alreadyUploaded") var alreadyUploaded = false
    @AppStorage("alreadyEnteredTheApp") var alreadyEnteredTheApp = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if alreadyEnteredTheApp {
                    NavigationStack {
                        HomeView()
                    }
                } else {
                    OnboardingView()
                }
            }
            .environment(\.managedObjectContext, gratidaoController.container.viewContext)
        }
    }
}
