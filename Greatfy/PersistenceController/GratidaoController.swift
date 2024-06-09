//
//  GratidaoController.swift
//  Gratify
//
//  Created by Caio Marques on 01/06/23.
//

import Foundation
import CoreData

class GratidaoController:ObservableObject {
    @Published var container : NSPersistentContainer
    
    static let compartilhado : GratidaoController  = GratidaoController()
    static let antigo : GratidaoController = GratidaoController(antigo: true)
    
    init(antigo : Bool = false){
        
        if antigo {
            self.container = NSPersistentContainer(name: "GratidaoModel")
            migrarDatabase()
        } else {
            self.container = NSPersistentContainer(name: "GratidaoModel")
            let url = URL.storeURL(for: "group.caio.gratify", databaseName: "GratidaoModel")
            let storeDescription = NSPersistentStoreDescription(url: url)
            container.persistentStoreDescriptions = [storeDescription]
        }
        container.loadPersistentStores{desc, error in
            if let error = error {
                print("Deu um erro ao carregar o dado \(error.localizedDescription)")
            }
        }
    }
    
    func migrarDatabase () {
        // pegar todos os dados do databaseAntigo
        let req = Gratidao.fetchRequest()
        let results = try? GratidaoController.antigo.container.viewContext.fetch(req)
        guard let results else { print("Erro ao carregar o database antigo"); return }
        
        // jogar os dados no database novo
        for result in results {
            let gratidaoCopiada = Gratidao(context: GratidaoController.compartilhado.container.viewContext)
            if let titulo = result.titulo { gratidaoCopiada.titulo = titulo }
            if let descricao = result.descricao { gratidaoCopiada.descricao = descricao }
            if let imagem = result.imagem { gratidaoCopiada.imagem = imagem }
            if let data = result.data { gratidaoCopiada.data = data }
            if let dataInclusao = result.dataInclusao { gratidaoCopiada.dataInclusao = dataInclusao }
            gratidaoCopiada.favoritado = result.favoritado
            
            salvar(context: GratidaoController.compartilhado.container.viewContext)
            self.excluirGratidao(gratidao: result, context: GratidaoController.antigo.container.viewContext)
        }
        
        
        
        // apagar os dados do database antigo
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
