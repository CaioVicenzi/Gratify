import Foundation
import SwiftUI

class ConfigureNotificationViewModel : ObservableObject {
    @Published var isToggleActive : Bool = false
    @Published var datetimeNotification : Date = Date()
    
    let handler = NotificationHandler()
    var dismissAction : DismissAction?
    
    func configure(_ dismissAction : DismissAction) {
        self.dismissAction = dismissAction
    }
    
    func readyButtonPressed() {
        if isToggleActive {
            handler.sendNotification(time: datetimeNotification)
        } else {
            handler.removeNotification()
        }
        
        if let dismissAction {
            dismissAction()
        }
    }
    
    func onLoadView() {
        handler.hasPermission {[weak self] hasPermission in
            if !hasPermission {
                self?.handler.askPermission()
            }
        }
        
        handler.isNotificationActive {[weak self] isActive in
            self?.isToggleActive = isActive
        }
        
        handler.getDatetimeLastNotification({[weak self] date in
            self?.datetimeNotification = date
        })
    }
    
    func onToggleChange(_ newValue : Bool) {
        if newValue == true {
            handler.askPermission()
        }
    }
}
