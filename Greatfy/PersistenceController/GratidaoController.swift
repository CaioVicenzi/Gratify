//
//  GratidaoController.swift
//  Gratify
//
//  Created by Caio Marques on 01/06/23.
//

import Foundation
import CoreData
import SwiftUI

class GratidaoController:ObservableObject {
    let container : NSPersistentContainer
    
    static let compartilhado : GratidaoController  = GratidaoController()
    @Published var semaforo = false
    
    init(){
        self.container = NSPersistentContainer(name: "GratidaoModel")
        let url = URL.storeURL(for: "group.caio.gratify", databaseName: "GratidaoModel")
        let storeDescription = NSPersistentStoreDescription(url: url)
        storeDescription.shouldMigrateStoreAutomatically = true
        storeDescription.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores{[weak self] desc, error in
            guard let self else {return}
            if let error = error {
                print("Deu um erro ao carregar o dado \(error.localizedDescription)")
            } else {
                self.migrarAntigoDatabase()
            }
        }
    }
    
    
    private func migrarAntigoDatabase () {
        let antigoDatabase = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("GratidaoModel.sqlite")
        if FileManager.default.fileExists(atPath: antigoDatabase.path) {
            do {
                let oldStore = try container.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: antigoDatabase)
                
                try container.persistentStoreCoordinator.replacePersistentStore(
                    at: container.persistentStoreDescriptions.first!.url!,
                    withPersistentStoreFrom: antigoDatabase,
                    ofType: NSSQLiteStoreType)
                
                try container.persistentStoreCoordinator.remove(oldStore)
                
                try FileManager.default.removeItem(at: antigoDatabase)
                print("Migração concluída com sucesso!")
                
                
                semaforo = true
            } catch {
                print("Erro ao migrare o banco de dados \(error.localizedDescription)")
            }
        }
    }
    
    func update (context: NSManagedObjectContext) {
        DispatchQueue.main.async {
            context.reset()
            try? context.save()
            NotificationCenter.default.post(name: .NSManagedObjectContextDidSave, object: context)
        }
    }
    
    func salvar(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Deu um erro ao salvar!!!")
        }
    }
    
    func adicionarGratidaoDiario (titulo:String, descricao:String, data : Date, context: NSManagedObjectContext) {
        let gratidao:Gratidao = Gratidao(context: context)
        gratidao.id = UUID()
        gratidao.data = data
        gratidao.titulo = titulo
        gratidao.descricao = descricao
        gratidao.dataInclusao = Date()
        
        salvar(context: context)
    }
    
    func adicionarGratidaoPorImagem (titulo:String, descricao:String, imageData:Data?, data: Date?,  context: NSManagedObjectContext){
        let gratidao:Gratidao = Gratidao(context: context)
        gratidao.id = UUID()
        gratidao.data = data
        gratidao.titulo = titulo
        gratidao.descricao = descricao
        gratidao.imagem = imageData
        gratidao.dataInclusao = Date()
        
        salvar(context: context)
    }
    
    func editarGratidao (gratidao:Gratidao, titulo:String, descricao:String, data: Date, imagem: Data?, context: NSManagedObjectContext) {
        gratidao.imagem = imagem
        gratidao.titulo = titulo
        gratidao.descricao = descricao
        gratidao.data = data
        salvar(context: context)
    }
    
    func mudarFavoritado (gratidao:Gratidao, context:NSManagedObjectContext){
        gratidao.favoritado.toggle()
        salvar(context: context)
    }
    
    func excluirGratidao (gratidao:Gratidao, context:NSManagedObjectContext){
        context.delete(gratidao)
        salvar(context: context)
    }
    
}


public extension URL {
    static func storeURL (for appGroup : String, databaseName : String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {fatalError("Não conseguimos criar uma URL para \(appGroup)")}
        
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
