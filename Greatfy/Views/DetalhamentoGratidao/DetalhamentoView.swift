//
//  DetalhamentoView.swift
//  Greatfy
//
//  Created by Caio Marques on 13/05/23.
//

import SwiftUI

struct DetalhamentoView: View {
    @StateObject var gratidao:Gratidao
    @Environment (\.managedObjectContext) var moc
    @StateObject var vm = DetalhamentoViewModel()
    @FocusState var modoEdicao
    
    // pegando a cor do ambiente
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        VStack {
            VStack{
                //MARK:  titulo
                if vm.mostrarPopupTituloLongo {
                    PopupErro(mostrarPopup: $vm.mostrarPopupTituloLongo)
                }
                    
                titulo
                Divider()
                
                //MARK: descricao
                HStack{
                    Text("Descrição")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    dataExibida
                }
                .padding(.horizontal)
                .foregroundColor(Color.accentColor)
                    
                descricao
                imagem
                dataInclusao
            }
            .onAppear{
                vm.setupTemps(moc: moc, gratidao: gratidao)
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(leading: BotaoVoltar()).toolbar{
                if vm.somethingChanged() {
                    ToolbarItem (placement: .automatic){
                        botaoFeito
                    }
                } else {
                    ToolbarItem (placement:.automatic) {
                        favButton
                    }
                    
                    ToolbarItem (placement: .automatic) {
                        shareButton
                    }
                }
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    let gratidaoPreview = Gratidao()
    gratidaoPreview.titulo = "Caio"
    gratidaoPreview.descricao = "Oliveira"
    gratidaoPreview.imagem =  UIImage(named: "nuvemrosa")?.pngData()
    
    return DetalhamentoView(gratidao: gratidaoPreview)
}
