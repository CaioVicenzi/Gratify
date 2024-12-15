import Foundation
import CoreData
import SwiftUI
import WidgetKit

class GratitudeController:ObservableObject {
    let container : NSPersistentContainer
    static let shared : GratitudeController  = GratitudeController()
    
    init(){
        self.container = NSPersistentContainer(name: "GratidaoModel")
        let url = URL.storeURL(for: "group.caio.gratify", databaseName: "GratidaoModel")
        let storeDescription = NSPersistentStoreDescription(url: url)
        storeDescription.shouldMigrateStoreAutomatically = true
        storeDescription.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores{desc, error in
            if let error = error {
                print("Deu um erro ao carregar o dado \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        WidgetCenter.shared.reloadTimelines(ofKind: "StreakWidget")

        do {
            try context.save()
        } catch {
            print("Deu um erro ao salvar!!!")
        }
    }
    
    func addGratitude(title:String, description:String, date : Date, context: NSManagedObjectContext) {
        let gratitude:Gratidao = Gratidao(context: context)
        gratitude.id = UUID()
        gratitude.data = date
        gratitude.titulo = title
        gratitude.descricao = description
        gratitude.dataInclusao = Date()

        save(context: context)
    }
    
    func addGratitude(title:String, description:String, imageData:Data?, date: Date?,  context: NSManagedObjectContext){
        let gratitude:Gratidao = Gratidao(context: context)
        gratitude.id = UUID()
        gratitude.data = date
        gratitude.titulo = title
        gratitude.descricao = description
        gratitude.imagem = imageData
        gratitude.dataInclusao = Date()
        
        save(context: context)
    }
    
    func editGratitude (gratitude:Gratidao, title:String, description:String, date: Date, imageData: Data?, context: NSManagedObjectContext) {
        gratitude.imagem = imageData
        gratitude.titulo = title
        gratitude.descricao = description
        gratitude.data = date
        save(context: context)
    }
    
    func toggleFavorited(gratitude:Gratidao, context:NSManagedObjectContext){
        gratitude.favoritado.toggle()
        save(context: context)
    }
    
    func deleteGratitude(gratitude:Gratidao, context:NSManagedObjectContext){
        context.delete(gratitude)
        save(context: context)
    }
}


public extension URL {
    static func storeURL (for appGroup : String, databaseName : String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {fatalError("Não conseguimos criar uma URL para \(appGroup)")}
        
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
