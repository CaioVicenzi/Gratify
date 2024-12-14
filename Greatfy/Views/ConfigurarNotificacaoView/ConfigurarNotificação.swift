//
//  ConfigurarNotificação.swift
//  Gratify
//
//  Created by Caio Marques on 26/10/23.
//

import SwiftUI

struct ConfigurarNotificacao: View {
    @Environment(\.dismiss) var dismiss
    @State var avisar : Bool = false
    @State var data : Date = Date()
    let notificador = NotificacaoHandler()

    var body: some View {
        NavigationView{
            VStack{
                Form {
                    Toggle(isOn: $avisar, label: {
                        Text("Me lembrar de ser grato")
                    }).onChange(of: avisar) { _, newValue in
                        if newValue == true {
                            notificador.pedirPermissao()
                        }
                    }
                    .tint(.accentColor)
                    
                    VStack{
                        if self.avisar {
                            DatePicker("Que horas deseja receber a notificação?", selection: $data, displayedComponents: .hourAndMinute)
                        }
                        Button {
                            if self.avisar {
                                notificador.mandarNotificacao(horas: data)
                            } else {
                                notificador.removerNotificacao()
                            }
                            dismiss()
                        } label: {
                            Text("Pronto")
                        }
                    }
                    
                    
                }
            }.navigationTitle("Configurar lembrete")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear(perform: {
                    avisar = notificador.existeNotificação()
                    if avisar {
                        notificador.pedirPermissao()
                    }
                    self.data = notificador.pegarHorarioUltimaNotificacao()
                })
        }
    }
}

#Preview {
    ConfigurarNotificacao()
}
