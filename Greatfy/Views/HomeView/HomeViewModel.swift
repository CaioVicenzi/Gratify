import Foundation
import SwiftUI
import WidgetKit

extension HomeView {
    class HomeViewModel : ObservableObject {
        @Published var showReminderSheet : Bool = false
        @Published var showInfoSheet : Bool = false
        @Published var searchText : String = ""
        @Published var showMaximizedStreak : Bool = false
        @Published var showRegisterGratitude : Bool = false
        @Published var sharedItem : Gratidao? = nil
        @Published var randomGratitude : Gratidao? = nil
        @Published var openSelectedGratitude : Bool = false
        @Published var openAlertGratitudeNotFound : Bool = false
        
        /// Streak e se já registrou hoje
        @Published var streak : Int = 0
        
        func calculateStreak (_ fetchedResults : FetchedResults<Gratidao>) -> Int {
            let calculator = StreakCalculator()
            calculator.configCalculator(fetchedResults: fetchedResults)
            return calculator.calculateStreak()
        }
        
        func wroteGratitudeToday(_ fetchedResults : FetchedResults<Gratidao>) -> Bool {
            let calculator = StreakCalculator()
            calculator.configCalculator(fetchedResults: fetchedResults)
            return calculator.didGratifyToday()
        }
        
        func dismissKeyboard () {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
        func rollDice (_ fetchedResults : FetchedResults<Gratidao>) {
            if let gratitude = fetchedResults.randomElement() {
                self.randomGratitude = gratitude
            } else {
                self.openAlertGratitudeNotFound = true
            }
        }
    }
}
