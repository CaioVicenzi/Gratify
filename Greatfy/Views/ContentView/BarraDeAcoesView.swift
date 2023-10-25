//
//  BarraDeAcoesView.swift
//  Gratify
//
//  Created by Caio Marques on 02/06/23.
//

import SwiftUI

struct BarraDeAcoesView : View {
    @State var abrirGratidaoSorteada:Bool = false
    @State var abrirDetalhamento:Bool = false
    @State var gratidaoSorteada:Gratidao?
    @FetchRequest(sortDescriptors: [SortDescriptor(\.data, order: .reverse)]) var gratidoes:FetchedResults<Gratidao>
    
    var body: some View {
        VStack{
            // BARRA DE ACOES
            if let gratidaoSorteada = gratidaoSorteada {
                NavigationLink(destination: DetalhamentoView(gratidao: gratidaoSorteada),isActive: $abrirDetalhamento) {
                    EmptyView()
                }.hidden()
            }
            HStack{
                Button {
                    if let gratidaoSorteada = gratidoes.randomElement() {
                        self.gratidaoSorteada = gratidaoSorteada
                    }
                    abrirGratidaoSorteada = true

                } label: {
                    Image(systemName: "dice")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26)
                        .padding(.horizontal)
                        .foregroundColor(Color(.systemPurple))
                }.alert(isPresented: $abrirGratidaoSorteada){
                    guard let gratidaoSorteada = gratidaoSorteada else{
                        return Alert(title: Text("Não encontramos nenhuma gratidão para sortear... 😔"))
                    }
    
                    return Alert(title: Text("Gratidão sorteada:"), message: Text("\(gratidaoSorteada.titulo ?? "titulo")"), primaryButton: .cancel(Text("Fechar")), secondaryButton: .default(Text("Abrir"), action: {
                        abrirDetalhamento = true
                    })
                    )
                }
                    
                Spacer()
                
                // dependendo da quantidade de gratidões salvas, o aplicativo exibe de uma forma diferente.
                Text(gratidoes.count > 1 ? "\(gratidoes.count) gratidões salvas!" : "\(gratidoes.count == 0 ? "Nenhuma" : gratidoes.count.description) gratidão salva!")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Spacer()
                    
                NavigationLink {
                    Registrar()
                }label: {
                    Image(systemName: "square.and.pencil")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26)
                    .padding(.horizontal)
                    .foregroundColor(Color(.systemPurple))
                }
            }.padding()
        }

    }
}
