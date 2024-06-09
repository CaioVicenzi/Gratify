//
//  ListItem.swift
//  Gratify
//
//  Created by Caio Marques on 07/06/24.
//

import SwiftUI

struct ListItem: View {
    var gratidao : Gratidao
    @Environment (\.managedObjectContext) var moc
    @Binding var sharedItem:Gratidao?
    
    var body: some View {
        VStack {
            HStack{
                title
                Spacer()
                date
            }.padding(.bottom, 2)
            HStack{
                if let descricaoCerteza = gratidao.descricao {
                    Text(descricaoCerteza)
                        .lineLimit(1)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if gratidao.favoritado{
                    Image(systemName: "heart.fill").foregroundColor(Color(.systemPurple))
                }
            }
        }
        .swipeActions(edge: .trailing, content: {
            
            // EXCLUIR
            Button (role: .destructive){
                HapticHandler.instance.notificacao(tipo: .warning)
                GratidaoController().excluirGratidao(gratidao: gratidao, context: moc)
            } label: {
                Image(systemName: "trash")
            }
            // COMPARTILHAR
            Button {
                sharedItem = gratidao
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            .tint(Color(.pinky))
        })
        
        
        .swipeActions(edge: .leading) {
            // FAVORITAR
            Button {
                HapticHandler.instance.impacto(estilo: .light)
                GratidaoController().mudarFavoritado(gratidao: gratidao, context: moc)
                
            } label: {
                
                Image(systemName: "heart")
                
            }.tint(gratidao.favoritado ? Color(.brightBlue) : Color(.systemPurple))
        }
        .sheet(item: $sharedItem) { item in
            if let titulo = item.titulo, let descricao = item.descricao, let data = item.data {
                let texto : String = "\(titulo)\n\n\(descricao)\n\nEstou fazendo um diário da gratidão no Gratify! Esse foi do dia \(data.formatted(date: .numeric, time: .omitted))\nFaça o seu também: https://apps.apple.com/br/app/gratify/id6449554523"
                ShareSheet(activityItems: [texto])
            }
        }
    }
    
    
    // MARK: UI COMPONENTS
    var title : some View {
        if let title = gratidao.titulo {
            Text(title)
                .font(.headline)
        } else {
            Text("")
        }
    }
    
    var date : some View {
        if let gratitudeDate = gratidao.data {
            Text(gratitudeDate.formatted(date: .numeric, time: .omitted))
                .fontWeight(.light)
                .font(.caption2)
                .foregroundColor(.gray)
        } else {
            Text("dd/mm/aaaa")
        }
    }
}

#Preview {
    ListItem(gratidao: Gratidao(), sharedItem: .constant(Gratidao()))
}
