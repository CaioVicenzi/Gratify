//
//  ElementoLista.swift
//  Gratify
//
//  Created by Caio Marques on 02/06/23.
//

import SwiftUI

struct ElementoLista: View {
    @Binding var elementoCompartilhado:Gratidao?
    @StateObject var gratidao:Gratidao
    @Environment (\.managedObjectContext) var moc
    var body: some View {
        VStack{
            HStack{
                Text("\(gratidao.titulo ?? "oi")").font(.headline)
                Spacer()
                if let dataCerteza = gratidao.data {
                    Text("\(dataCerteza.formatted(date: .numeric, time: .omitted))").fontWeight(.light).font(.caption2).foregroundColor(.gray)
                    
                }
            }.padding(.bottom, 2)
            
            HStack{
                if let descricaoCerteza = gratidao.descricao {
                    if descricaoCerteza.count > 35 {
                        Text((descricaoCerteza.split(separator: "\n").first?.prefix(35) ?? "descrição") + "...")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    } else {
                        Text(descricaoCerteza.split(separator: "\n").first ?? "descrição")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    
                }
                Spacer()
                
                
                if gratidao.favoritado{
                    Image(systemName: "heart.fill").foregroundColor(Color(.systemPurple))
                }
                
            } // final do HStack
        }.swipeActions(edge: .trailing, content: {
            
            // EXCLUIR
            Button (role: .destructive){
                GratidaoController().excluirGratidao(gratidao: gratidao, context: moc)
            } label: {
                Image(systemName: "trash")
            }
            // COMPARTILHAR
            Button {
                elementoCompartilhado = gratidao
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            .tint(corSecundaria)
        })
        
        
        .swipeActions(edge: .leading) {
            // FAVORITAR
            Button {
                GratidaoController().mudarFavoritado(gratidao: gratidao, context: moc)
                
            } label: {
                
                Image(systemName: "heart")
                
            }.tint(gratidao.favoritado ? corTerciaria : Color(.systemPurple))
        }
        
    }
    

}

