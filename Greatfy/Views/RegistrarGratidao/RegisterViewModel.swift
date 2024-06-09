//
//  RegisterViewModel.swift
//  Gratify
//
//  Created by Caio Marques on 08/06/24.
//

import Foundation
import CoreData
import SwiftUI
import WidgetKit

extension RegistrarGratidaoView {
    class RegisterViewModel : ObservableObject {
        @Published var titulo:String = ""
        @Published var descricao:String = ""
        
        @Published var tituloParaImagem:String = ""
        @Published var descricaoParaImagem:String = ""
        
        @Published var data:Date = Date()
        @Published var imagemData:Data? = nil
        @Published var salvarComData : Bool = false
        @Published var vazio : Bool = false
        @Published var mostrarStreakAumentando : Bool = false
        
        @Published var escolherData : Bool = false
        @Published var actionSheetAparecendo : Bool = false
        @Published var imagePicker = false
        @Published var camera = false
        @Published var mostrarPopup : Bool = false
        
        @AppStorage("hojeRegistrou", store: UserDefaults(suiteName: "group.caio.gratify")) var hojeRegistrou : Bool = false

        
        var moc : NSManagedObjectContext? = nil
        var dismiss : DismissAction?
        
        func configVM (moc : NSManagedObjectContext, dismiss: DismissAction) {
            self.moc = moc
            self.dismiss = dismiss
        }
        
        func saveGratitude () {
            guard let moc else {
                print("Não conseguimos salvar a gratidão porque não tem moc")
                return
            }
            
            if (!(titulo.isEmpty) && !(descricao.isEmpty)) {
                HapticHandler.instance.notificacao(tipo: .success)
                GratidaoController().adicionarGratidaoPorImagem(titulo: titulo, descricao: descricao, imageData: imagemData, data: data, context: moc)
                if hojeRegistrou {
                    if let dismiss {
                        dismiss()
                    }
                } else {
                    WidgetCenter.shared.reloadTimelines(ofKind: "StreakWidget")

                    // atualizar widget
                    mostrarStreakAumentando = true
                }
                
            } else {
                HapticHandler.instance.notificacao(tipo: .error)
                vazio = true
            }
        }
        
        func returnAlert () -> Alert {
            var faltou = "Faltou "
            
            if titulo.isEmpty {
                faltou += "titulo "
                if descricao.isEmpty {
                    faltou += "e "
                }
            }
            
            if descricao.isEmpty {
                faltou += "descricao"
            }
            
            return Alert(title: Text(faltou))
        }
        
        func titleValueChanged (newValue : String) {
            if newValue.count > limiteTitulo {
                titulo = String(describing: newValue.prefix(limiteTitulo))
                withAnimation {
                    mostrarPopup = true
                }
            }
        }
    }
}
