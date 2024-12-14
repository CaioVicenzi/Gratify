//
//  NotificacaoHandler.swift
//  Gratify
//
//  Created by Caio Marques on 25/10/23.
//

import Foundation
import UserNotifications
//
class NotificacaoHandler {
    static var temPermissao = false
    func pedirPermissao () {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { sucesso, erro in
            if sucesso {
                print("Deu tudo certo na permissão")
                NotificacaoHandler.temPermissao = true
            } else if let erro = erro {
                print("O erro foi \(erro.localizedDescription)")
            }
        }
    }
    
    func mandarNotificacao (horas : Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: horas)
        
        let conteudoNotificacao = UNMutableNotificationContent()
        conteudoNotificacao.title = "Lembre-se de ser grato!"
        conteudoNotificacao.body = "Você tem vários motivos para ser grato, o que você foi grato hoje?"
        conteudoNotificacao.sound = .default
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        
        let requisicao = UNNotificationRequest(identifier: "notificacao", content: conteudoNotificacao, trigger: trigger)
        
        UNUserNotificationCenter.current().add(requisicao)
        
    }
    
    func existeNotificação () -> Bool {
        let notificationCenter = UNUserNotificationCenter.current()
        var existeNotificacao = false
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global(qos: .background).async {

            notificationCenter.getPendingNotificationRequests { requests in
                for request in requests {
                    if request.identifier == "notificacao" {
                        existeNotificacao = true
                    }
                }
                semaphore.signal() // Libera o semáforo quando a busca estiver concluída
            }
        }
        
        semaphore.wait() // Espera até que o semáforo seja sinalizado
        return existeNotificacao
    }
    
    
    // função que é executada quando o usuário termina a configuração da notificação com o
    func removerNotificacao () {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func pegarHorarioUltimaNotificacao () -> Date {
        var data = Date()
        let semaphore = DispatchSemaphore(value: 0)
        let notificacaoCentar = UNUserNotificationCenter.current()
        
        DispatchQueue.global(qos: .background).async(execute: {
            notificacaoCentar.getPendingNotificationRequests { notificacoes in
                for notificacoe in notificacoes {
                    if notificacoe.identifier == "notificacao" {
                        if let notificacao = notificacoe.trigger as? UNCalendarNotificationTrigger{
                            data = Calendar.current.date(from: notificacao.dateComponents) ?? Date()
                        }
                    }
                    
                }
                semaphore.signal()

            }
        })
        
        semaphore.wait()
        return data
    }
    
}
