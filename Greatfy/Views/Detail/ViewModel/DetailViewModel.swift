import Foundation
import SwiftUI
import CoreData

class DetailViewModel : ObservableObject {
    // MARK: VARIÁVEIS
    // 1) variáveis de ativação
    @Published var addImage : Bool = false
    
    @Published var openImagePicker = false
    @Published var openCamera = false
    @Published var openShare : Bool = false
    
    @Published var showLongTitleError : Bool = false
    @Published var showEmptyFieldsError : Bool = false
    
    // 2) variáveis temporárias (enquanto o user está alterando os dados)
    @Published var temporaryTitle:String = ""
    @Published var temporaryDescription:String = ""
    @Published var temporaryImage : Data? = nil
    @Published var temporaryDate : Date = Date()
    
    // 3) variáveis de fora
    @Published var gratitude:Gratidao?
    @Published var moc : NSManagedObjectContext? = nil
    
    let limitLetters = 30
    
    init() {}
    
    /// Função que retorna true se algum dos campos, a imagem ou a data mudou(aram).
    func somethingChanged () -> Bool {
        guard let gratitude else {
            return false
        }
        
        return gratitude.descricao != temporaryDescription || gratitude.titulo != temporaryTitle || gratitude.data != temporaryDate || ((temporaryImage != nil) != (gratitude.imagem != nil))
    }
    
    // faz o setup dos temporários.
    func setupTemps (moc : NSManagedObjectContext, gratitude : Gratidao) {
        self.moc = moc
        self.gratitude = gratitude
        
        guard let gratitude = self.gratitude else { return }
        temporaryTitle = gratitude.titulo ?? "titulo"
        temporaryDescription = gratitude.descricao ?? "descricao"
        
        if let dataGratidao = gratitude.data {
            self.temporaryDate = dataGratidao
        }
        
        if let imagemGratidao = gratitude.imagem {
            self.temporaryImage = imagemGratidao
        }
    }
    
    // função rodada sempre que o título muda.
    func onChangeTitle () {
        if temporaryTitle.count > limitLetters {
            temporaryTitle = String(temporaryTitle.prefix(limitLetters))
            
            withAnimation {
                showLongTitleError = true
            }
        }
    }
    
    func doneButtonPressed () {
        guard let moc = self.moc, let gratitude else {
            print("Erro! Não conseguimos salvar pq não tem moc.")
            return
        }
        
        if temporaryTitle == "" || temporaryDescription == "" {
            showEmptyFieldsError = true
        } else {
            temporaryTitle = temporaryTitle
            temporaryDescription = temporaryDescription
            
            GratitudeController().editGratitude(
                gratitude: gratitude,
                title: temporaryTitle,
                description: temporaryDescription,
                date: temporaryDate,
                imageData: temporaryImage,
                context: moc
            )
            HapticHandler.instance.notification(feedbackType: .success)
        }
    }
    
    func shareGratitude () -> some View {
        guard let gratitude else { return ShareSheet(activityItems: []) }
        
        let texto : String = "\(gratitude.titulo ?? "")\n\n\(gratitude.descricao ?? "")\n\nEstou fazendo um diário da gratidão no Gratify! \nFaça o seu também: https://apps.apple.com/br/app/gratify/id6449554523"
        return ShareSheet(activityItems: [texto])
    }
}



