//
//  GratidaoController.swift
//  Gratify
//
//  Created by Caio Marques on 01/06/23.
//

import Foundation
import CoreData

class GratidaoController:ObservableObject {
    let container = NSPersistentContainer(name: "GratidaoModel")
    
    init(){
        container.loadPersistentStores{desc, error in
            if let error = error {
                print("Deu um erro ao carregar o dado \(error.localizedDescription)")
            }
        }
    }
    
    func salvar(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Deu um erro ao salvar!!!")
        }
    }
    
    func adicionarGratidaoDiario (titulo:String, descricao:String, context: NSManagedObjectContext) {
        let gratidao:Gratidao = Gratidao(context: context)
        gratidao.id = UUID()
        gratidao.data = Date()
        gratidao.titulo = titulo
        gratidao.descricao = descricao
        
        salvar(context: context)
    }
    
    func adicionarGratidaoPorImagem (titulo:String, descricao:String, imageData:Data, context: NSManagedObjectContext){
        let gratidao:Gratidao = Gratidao(context: context)
        gratidao.id = UUID()
        gratidao.titulo = titulo
        gratidao.descricao = descricao
        gratidao.imagem = imageData
        
        salvar(context: context)
    }
    
    func editarGratidao (gratidao:Gratidao, titulo:String, descricao:String, context: NSManagedObjectContext) {
        gratidao.titulo = titulo
        gratidao.descricao = descricao
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
