//
//  SearchBar.swift
//  Greatfy
//
//  Created by Caio Marques on 21/05/23.
//

import SwiftUI

struct BarraDePesquisaFiltro: View {
    @Binding var pesquisa:String
    @Binding var filtrado:Bool
    
    @State var nomeImagem : String = "line.3.horizontal.decrease.circle"
    
    var body: some View {
        HStack{
            TextField("Pesquisar", text: $pesquisa).padding(7).padding (.horizontal, 34)
                .submitLabel(.search)
                .background(Color(.systemGray6))
                .cornerRadius(8).padding(.horizontal, 10)
                .overlay(
                    HStack {
                        // exibe o icone da lupa
                        Image(systemName: "magnifyingglass")
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                            .foregroundColor(Color(.systemGray))
                        Spacer()
                        
                        Button {
                            pesquisa = ""
                        } label: {
                            // Se tiver algo escrito no searchbar, aparece um xmark para que quando o usuário aperte nela, lime a pesquisa
                            if pesquisa != ""{
                                Image(systemName: "xmark.circle.fill").foregroundColor(Color(.systemGray2))
                                
                            }
                        }
                    }.padding())
            
            //  BOTAO DE FILTRO
            Button {
                filtrado.toggle()
            } label: {
                Image(systemName: filtrado == false ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26.0)
                    .foregroundColor(.accentColor)
            }
        }
    }
}
