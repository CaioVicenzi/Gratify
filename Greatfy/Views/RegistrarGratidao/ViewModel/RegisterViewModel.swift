import Foundation
import CoreData
import SwiftUI
import WidgetKit

class RegisterViewModel : ObservableObject {
    @Published var titulo:String = ""
    @Published var descricao:String = ""
    @Published var page : Int = 0
    @Published var data:Date = Date()
    @Published var imagemData:Data? = nil
    
    @Published var goGrowStreak : Bool = false
    
    @Published var showEmptyFieldError : Bool = false
    @Published var showActionSheet : Bool = false
    @Published var showImagePicker = false
    @Published var showCamera = false
    @Published var showLongTitleError : Bool = false
    
    var moc : NSManagedObjectContext? = nil
    var dismiss : DismissAction?
    
    let limitLetters = 30
    
    func configVM(moc : NSManagedObjectContext, dismiss: DismissAction) {
        self.moc = moc
        self.dismiss = dismiss
    }
    
    func saveGratitude() {
        guard let moc else {
            print("Não conseguimos salvar a gratidão porque não tem moc")
            return
        }
        
        if (!(titulo.isEmpty) && !(descricao.isEmpty)) {
            HapticHandler.instance.notification(feedbackType: .success)
            
            let calculator = StreakCalculator()
            guard let gratitudes = try? moc.fetch(Gratidao.fetchRequest()) else {
                print("[ERROR] Error fetching CoreData Gratidao")
                return
            }
            
            GratitudeController().addGratitude(title: titulo, description: descricao, imageData: imagemData, date: data, context: moc)
            
            let didSaveGratitudeToday = calculator.didWriteGratitudeToday(gratitudes)
            if didSaveGratitudeToday {
                if let dismiss {
                    dismiss()
                }
            } else {
                goGrowStreak = true
            }
        } else {
            HapticHandler.instance.notification(feedbackType: .error)
            showEmptyFieldError = true
        }
    }
    
    func gratifiedToday() -> Bool {
        let streakCalculator = StreakCalculator()
        let fetchRequest = FetchRequest<Gratidao>(entity: Gratidao.entity(), sortDescriptors: [])
        let gratidoes = fetchRequest.wrappedValue
        
        streakCalculator.configCalculator(fetchedResults: gratidoes)
        return streakCalculator.didWriteGratitudeToday()
    }
    
    func nextButtonPressed() {
        if page >= 2 {
            saveGratitude()
        } else {
            withAnimation {
                if page == 0 {
                    if !descricao.isEmpty {
                        page += 1
                    } else {
                        showEmptyFieldError = true
                    }
                } else if page == 1 {
                    page += 1
                } else {
                    if !titulo.isEmpty {
                        showEmptyFieldError = true
                    } else {
                        page += 1
                    }
                }
            }
        }
    }
    
    func goBackButtonPressed() {
        withAnimation (.spring) {
            if page >= 1 {
                page -= 1
            }
        }
    }
    
    func excludeImageButtonPressed() {
        withAnimation (.spring) {
            imagemData = nil
        }
    }
    
    func onChangeTitle(_ oldValue : String, _ newValue : String) {
        if newValue.count > limitLetters {
            withAnimation {
                showLongTitleError = true
            }
            titulo = oldValue
        }
    }
    
    @ViewBuilder
    func fieldsToShow(_ page : Int) -> some View {
        if page == 0 {
            RegisterDescriptionView(vm: self)
        } else if page == 1 {
            RegisterDetailsView(vm: self)
        } else {
            RegisterTitleView(vm: self)
        }
    }
}

