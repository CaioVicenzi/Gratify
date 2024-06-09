//
//  HomeViewModel.swift
//  Gratify
//
//  Created by Caio Marques on 07/06/24.
//

import Foundation
import SwiftUI
import WidgetKit

extension HomeView {
    class HomeViewModel : ObservableObject {
        @Published var showReminderSheet : Bool = false
        @Published var showInfoSheet : Bool = false
        @Published var searchText : String = ""
        @Published var showMaximizedStreak : Bool = false
        @Published var streak : Int = 0
        @Published var wroteGratitudeToday : Bool = false
        @Published var showRegisterGratitude : Bool = false
        @Published var sharedItem : Gratidao? = nil
        @Published var randomGratitude : Gratidao? = nil
        @Published var openSelectedGratitude : Bool = false
        @Published var openAlertGratitudeNotFound : Bool = false
        var gratidoes:FetchedResults<Gratidao>? = nil
        
        func config (gratidoes : FetchedResults<Gratidao>) {
            self.gratidoes = gratidoes
            calculateStreak()
        }
        
        func calculateStreak () {
            guard let gratidoes else {
                streak = 0
                print("Nenhuma gratitude hoje")
                return
            }
            
            // trecho de código importante haja vista que sem ele se tivesse nenhuma gratidão ele não entraria no bloco de código onde iria se calcular se hoje ele registrou ou não.
            if gratidoes.count == 0 {
                self.wroteGratitudeToday = false
            }
            
            var streak = 0
            
            // primeiro: ordene a lista da gratidão mais recente para a mais posterior
            let copiasGratidao = Array(gratidoes)
            
            // dia anterior e dia anterior de antes (o dia anterior da última rodada
            var diaAnterior = Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())
            var diaAnteriorDeAntes : Date? = Date()
            
            
            // segundo: verificar se hoje ou ontem foi grato
            if let ultimaGratidao = copiasGratidao.first?.dataInclusao {
                if Calendar.current.isDateInToday(ultimaGratidao) {
                    wroteGratitudeToday = true
                } else {
                    wroteGratitudeToday = false
                }
                
                if Calendar.current.isDateInToday(ultimaGratidao) || Calendar.current.isDateInYesterday(ultimaGratidao) {
                    streak += 1
                    
                    
                    // se o dia foi ontem, então tem que diminuir os dois antes do loop
                    if Calendar.current.isDateInYesterday(ultimaGratidao) {
                        diaAnterior = Calendar.current.date(byAdding: DateComponents(day: -2), to: Date())
                        diaAnteriorDeAntes = Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())
                    }
                    // terceiro: fazer um loop que verifica se a data da gratidão é o mesmo dia de ontem, se for, aumenta a streak em um e diminui um dia no diaAnterior e no diaAnteriorDeAntes
                    for i in 1 ..< copiasGratidao.count {
                        if let data = copiasGratidao[i].dataInclusao {
                            if Calendar.current.isDate(diaAnterior ?? Date(), inSameDayAs: data) {
                                streak += 1
                                
                                if let diaAnteriorCerteza = diaAnterior, let diaAnteriorDeAntesCerteza = diaAnteriorDeAntes{
                                    diaAnterior = Calendar.current.date(byAdding: DateComponents(day: -1), to: diaAnteriorCerteza)
                                    
                                    diaAnteriorDeAntes = Calendar.current.date(byAdding: DateComponents(day: -1), to: diaAnteriorDeAntesCerteza)
                                }
                                // caso contrário (se a data não é no dia anterior nem no dia), simplesmente quebra o laço
                            } else if !Calendar.current.isDate(data, inSameDayAs: diaAnteriorDeAntes!){
                                break
                            }
                        }
                    }
                }
            }
            
            // retorna a streak
            self.streak = streak
            WidgetCenter.shared.reloadTimelines(ofKind: "StreakWidget")
        }
        
        func dismissKeyboard () {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
        func rollDice () {
            guard let gratidoes else {
                print("Erro ao encontrar as gratidões.")
                return
            }
            
            if let gratitude = gratidoes.randomElement() {
                self.randomGratitude = gratitude
            } else {
                self.openAlertGratitudeNotFound = true
            }
        }
    }
}
