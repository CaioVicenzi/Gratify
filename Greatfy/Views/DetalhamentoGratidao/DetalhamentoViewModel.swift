//
//  DetalhamentoViewModel.swift
//  Gratify
//
//  Created by Caio Marques on 07/06/24.
//

import Foundation
import SwiftUI
import CoreData

extension DetalhamentoView {
    class DetalhamentoViewModel : ObservableObject {
        // MARK: VARIÁVEIS
        
        // 1) variáveis de ativação
        @Published var compartilhamentoApresentado:Bool = false
        @Published var adicionarImagem : Bool = false
        @Published var imagePicker = false
        @Published var camera = false
        @Published var mostrarPopupTituloLongo = false
        @Published var camposVazios:Bool = false
        
        // 2) variáveis temporárias (enquanto o user está alterando os dados)
        @Published var tituloTemporario:String = ""
        @Published var descricaoTemporaria:String = ""
        @Published var imagemTemporaria : Data? = nil
        @Published var dataTemporaria : Date = Date()
                
        // 3) variáveis de fora
        @Published var gratidao:Gratidao?
        @Published var moc : NSManagedObjectContext? = nil
        
        let limitLetters = 30
                
        init() {}
        
        func somethingChanged () -> Bool {
            guard let gratidao else {
                return false
            }
            
            return gratidao.descricao != descricaoTemporaria || gratidao.titulo != tituloTemporario || gratidao.data != dataTemporaria || ((imagemTemporaria != nil) != (gratidao.imagem != nil))
        }
        
        func setupTemps (moc : NSManagedObjectContext, gratidao : Gratidao) {
            self.moc = moc
            self.gratidao = gratidao
            
            guard let gratitude = self.gratidao else { return }
            tituloTemporario = gratitude.titulo ?? "titulo"
            descricaoTemporaria = gratitude.descricao ?? "descricao"
            
            if let dataGratidao = gratitude.data {
                self.dataTemporaria = dataGratidao
            }
            
            if let imagemGratidao = gratitude.imagem {
                self.imagemTemporaria = imagemGratidao
            }
        }
        
        func changeTitle () {
            if tituloTemporario.count > limitLetters {
                tituloTemporario = String(tituloTemporario.prefix(limitLetters))
                
                withAnimation {
                    mostrarPopupTituloLongo = true
                }
            }
        }
        
        func doneButtonPressed () {
            guard let moc = self.moc, let gratidao else {
                print("Erro! Não conseguimos salvar pq não tem moc.")
                return
            }
            
            if tituloTemporario == "" || descricaoTemporaria == "" {
                camposVazios = true
            } else {
                tituloTemporario = tituloTemporario
                descricaoTemporaria = descricaoTemporaria
                GratitudeController().editGratitude(gratitude: gratidao, title: tituloTemporario, description: descricaoTemporaria, date: dataTemporaria, imageData: imagemTemporaria, context: moc)
                HapticHandler.instance.notification(feedbackType: .success)
            }
        }
        
        func shareGratitude () -> some View {
            guard let gratidao else { return ShareSheet(activityItems: []) }
            
            let texto : String = "\(gratidao.titulo ?? "")\n\n\(gratidao.descricao ?? "")\n\nEstou fazendo um diário da gratidão no Gratify! \nFaça o seu também: https://apps.apple.com/br/app/gratify/id6449554523"
            return ShareSheet(activityItems: [texto])
        }
    }
    
}

