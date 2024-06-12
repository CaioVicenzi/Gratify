//
//  SaveGratitudeAppIntent.swift
//  StreakWidgetExtension
//
//  Created by Caio Marques on 12/06/24.
//

import Foundation
import AppIntents

struct SaveGratitudeAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Salvar gratidão"
    
    static var description = IntentDescription("Salve uma gratidão de maneira prática e simples com comandos de voz ou atalho")
    
    @Parameter (title: "Insira um motivo pelo qual você é grato")
    var title : String
    
    @Parameter (title: "Por que você é grato por isso?")
    var description : String
    
    // Intent para aumentar a barra / alimentar o buddy
    func perform() async throws -> some ProvidesDialog & ShowsSnippetView {
        
        GratidaoController().adicionarGratidaoDiario(titulo: title, descricao: description, data: Date(), context: GratidaoController.compartilhado.container.viewContext)
        
        return .result(dialog: "Gratidão salva!")
    }
}
