//
//  InformationShortcutsView.swift
//  StreakWidgetExtension
//
//  Created by Caio Marques on 12/06/24.
//

import SwiftUI

struct InformationShortcutsView: View {
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 10){
                Text("Use o Gratify fora do Gratify!")
                    .font(.title)
                    .foregroundStyle(Color.accentColor)
                    .bold()
                Text("As novas formas de usar o Gratify incluem salvar novas gratidões e consultar sua streak fora do aplicativo, para que você não precise abrir o app para fazer essas pequenas tarefas!")
                
                tituloSecao("Widget")
                
                Text("O widget do Gratify de permite acompanhar a sua streak e se lembrar de ser grato no dia.")
                
                tituloSecao("Siri")
                
                Text("Através da Siri é possível adicionar uma gratidão pelos seguintes comandos de vez")
                listItem("Salve uma gratidão no Gratify")
                listItem("Registre uma gratidão no Gratify")
                listItem("Escreva uma gratidão no Gratify")
                listItem("Escreva uma gratidão para mim no Gratify")
                listItem("Nova gratidão no Gratify")
                
                tituloSecao("Atalho")
                
                Text("O atalho também te permite registrar uma gratidão nova no Gratify com um título e uma descrição")
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func tituloSecao (_ texto : String) -> some View {
        Text(texto)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(Color.accentColor)
    }
    
    @ViewBuilder
    func listItem (_ texto : String) -> some View {
        HStack {
            Image(systemName: "circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 10)
            Text(texto)
        }
    }
}

#Preview {
    InformationShortcutsView()
}
