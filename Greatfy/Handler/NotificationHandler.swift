import Foundation
import UserNotifications

class NotificationHandler {
    /// Função criada para pedir a permissão do usuário para enviar notificações.
    func askPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error {
                print("[ERROR] Could not request authorization: \(error.localizedDescription)")
            }
        }
    }
    
    func hasPermission(_ completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func sendNotification(time : Date) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        
        let content = UNMutableNotificationContent()
        content.title = "Lembre-se de ser grato!"
        content.body = "Você tem vários motivos para ser grato, o que você foi grato hoje?"
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func isNotificationActive(_ completion : @escaping (Bool) -> Void) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getPendingNotificationRequests { requests in
            for request in requests {
                if request.identifier == "notification" {
                    completion(true)
                }
            }
        }
    }
    
    // função que é executada quando o usuário termina a configuração da notificação da notificação
    func removeNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func getDatetimeLastNotification(_ completion : @escaping (Date) -> Void) {
        let notificationCenter = UNUserNotificationCenter.current()

        notificationCenter.getPendingNotificationRequests { notifications in
            for notification in notifications {
                if notification.identifier == "notification" {
                    if let notificacao = notification.trigger as? UNCalendarNotificationTrigger {
                        let date = Calendar.current.date(from: notificacao.dateComponents) ?? Date()
                        completion(date)
                    }
                }
            }
        }
    }
}
