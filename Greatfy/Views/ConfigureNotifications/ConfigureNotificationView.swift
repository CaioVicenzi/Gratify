import SwiftUI

struct ConfigureNotification: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm = ConfigureNotificationViewModel()

    var body: some View {
        NavigationView{
            VStack{
                Form {
                    Toggle(isOn: $vm.isToggleActive, label: {
                        Text("Me lembrar de ser grato")
                    }).onChange(of: vm.isToggleActive) { _, newValue in
                        vm.onToggleChange(newValue)
                    }
                    .tint(.accentColor)
                    
                    VStack{
                        if vm.isToggleActive {
                            DatePicker("Que horas deseja receber a notificação?", selection: $vm.datetimeNotification, displayedComponents: .hourAndMinute)
                        }
                        Button {
                            vm.readyButtonPressed()
                        } label: {
                            Text("Pronto")
                        }
                    }
                    
                    
                }
            }.navigationTitle("Configurar lembrete")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear(perform: {
                    vm.configure(dismiss)
                    vm.onLoadView()
                })
        }
    }
}
