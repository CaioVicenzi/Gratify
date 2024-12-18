import Foundation
import CoreData
import SwiftUI

class StreakCalculator {
    var fetchedResults : FetchedResults<Gratidao>? = nil
    
    func configCalculator (fetchedResults : FetchedResults<Gratidao>) {
        self.fetchedResults = fetchedResults
    }
    
    func calculateStreak () -> Int {
        guard let fetchedResults else {
            return 0
        }
        
        // trecho de código importante haja vista que sem ele se tivesse nenhuma gratidão ele não entraria no bloco de código onde iria se calcular se hoje ele registrou ou não.
        if fetchedResults.count == 0 {
            return 0
        }
                
        // primeiro: ordene a lista da gratidão mais recente para a mais posterior
        let copiasGratidao = Array(fetchedResults)
        return calculateStreak(copiasGratidao)
    }
    
    func calculateStreak(_ gratitudes : [Gratidao]) -> Int {
        if gratitudes.count == 0 {
            return 0
        }
        
        let gratitudeCopies = gratitudes.sorted { g1, g2 in
            guard let inclusionDate1 = g1.dataInclusao, let inclusionDate2 = g2.dataInclusao else {
                return g1.data?.timeIntervalSince1970 ?? 2 > g2.data?.timeIntervalSince1970 ?? 1
            }
            return inclusionDate1.timeIntervalSince1970 > inclusionDate2.timeIntervalSince1970
        }
        
        return calculateStreak(from: gratitudeCopies)
    }
    
    private func calculateStreak(from gratitudes : [Gratidao]) -> Int {
        var streak = 0
        
        // dia anterior e dia anterior de antes (o dia anterior da última rodada
        var diaAnterior = Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())
        var diaAnteriorDeAntes : Date? = Date()
        
        // segundo: verificar se hoje ou ontem foi grato
        if let ultimaGratidao = gratitudes.first?.dataInclusao {
            if Calendar.current.isDateInToday(ultimaGratidao) || Calendar.current.isDateInYesterday(ultimaGratidao) {
                streak += 1
                
                
                // se o dia foi ontem, então tem que diminuir os dois antes do loop
                if Calendar.current.isDateInYesterday(ultimaGratidao) {
                    diaAnterior = Calendar.current.date(byAdding: DateComponents(day: -2), to: Date())
                    diaAnteriorDeAntes = Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())
                }
                // terceiro: fazer um loop que verifica se a data da gratidão é o mesmo dia de ontem, se for, aumenta a streak em um e diminui um dia no diaAnterior e no diaAnteriorDeAntes
                for i in 1 ..< gratitudes.count {
                    if let data = gratitudes[i].dataInclusao {
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
        
        return streak
    }

    
    func didWriteGratitudeToday () -> Bool {
        let didWrote = fetchedResults?.contains { gratitude in
            if let dataInclusao = gratitude.dataInclusao {
                return Calendar.current.isDateInToday(dataInclusao)
            }
            return false
        }
        
        return didWrote == true
    }
    
    
    func didWriteGratitudeToday (_ gratitudes : [Gratidao]) -> Bool {
        let didWrote = gratitudes.contains { gratitude in
            if let inclusionDate = gratitude.dataInclusao {
                return Calendar.current.isDateInToday(inclusionDate)
            }
            return false
        }
        
        return didWrote
    }
}
