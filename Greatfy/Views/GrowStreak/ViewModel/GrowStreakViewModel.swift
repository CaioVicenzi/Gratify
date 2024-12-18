import Foundation
import CoreData
import SwiftUI

class GrowStreakViewModel : ObservableObject {
    @Published var animateHand : Bool = false
    @Published var animateLabel : Bool = false
    @Published var animateButton : Bool = false
    @Published var goHomeView : Bool = false
    @Published var calculatedStreak : Int = 0
    
    func viewDidAppear(_ moc : NSManagedObjectContext) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            withAnimation (Animation.spring(bounce: 0.8)) {
                self.animateHand = true
            }
            
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            withAnimation (Animation.spring(bounce: 0.8)) {
                self.animateLabel = true
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            withAnimation (Animation.easeIn) {
                self.animateButton = true
            }
        })
        
        self.calculatedStreak = calculateStreak(moc)
    }
    
    func calculateStreak(_ moc : NSManagedObjectContext) -> Int {
        let calculator = StreakCalculator()
        let request = Gratidao.fetchRequest()
        let gratidoes = try? moc.fetch(request)
        if let gratidoes {
            return calculator.calculateStreak(gratidoes)
        } else {
            print("[ERROR] gratidoes é null")
            return 0
        }
    }
    
    func buttonPressed() {
        HapticHandler.instance.impact(feedbackStyle: .medium)
        goHomeView = true
    }
}
