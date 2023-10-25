//
//  ContentView.swift
//  Gratify
//
//  Created by Caio Marques on 01/06/23.
//

import SwiftUI


enum tipoSecao : String{
    case diarioGratidao = "Diário da Gratidão", gratidaoPorImagem = "Gratidão por Imagem"
}

struct ContentView: View {
    @State var pesquisa:String = ""
    @State var filtrado:Bool = false
    @State var grupoDoDiarioAberto = false
    @State var grupoDaImagemAberto = false
    @State var compartilhamentoAberto:Bool = false
    @State var elementoCompartilhado:Gratidao? = nil
    
    @Environment (\.managedObjectContext) var moc
    @Environment (\.colorScheme) var colorScheme
    @FetchRequest(sortDescriptors: [SortDescriptor(\.data, order: .reverse)]) var gratidoes:FetchedResults<Gratidao>
    
    func dismissTeclado() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Rectangle().frame(maxWidth: .infinity, maxHeight: .infinity).onTapGesture {
                    dismissTeclado()
                }.foregroundColor(colorScheme == .light ? .white : .black)
                VStack{
                    HStack{
                        Text("Gratify")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .padding()
                        Spacer()
                        
                    }
                    .padding(.leading, 10)
                    .padding(.top)
                    
                    
                    BarraDePesquisaFiltro(pesquisa: $pesquisa, filtrado: $filtrado)
                    
                    
                    if !gratidoes.isEmpty {
                        List{
                            SecaoListaView(tipo: tipoSecao.diarioGratidao,  filtrado: $filtrado, grupoAberto: $grupoDoDiarioAberto, pesquisa: $pesquisa, elementoCompartilhado: $elementoCompartilhado)
                            SecaoListaView(tipo: tipoSecao.gratidaoPorImagem, filtrado: $filtrado, grupoAberto: $grupoDaImagemAberto, pesquisa: $pesquisa, elementoCompartilhado: $elementoCompartilhado)
                        }.listStyle(.automatic)
                            .sheet(item: $elementoCompartilhado) {gratidao in
                                if let titulo = gratidao.titulo, let descricao = gratidao.descricao, let data = gratidao.data {
                                    ShareSheet(activityItems: ["\(titulo)\n\n\(descricao)\n\nEstou fazendo um diário da gratidão no Gratify! Esse é do dia \(data.formatted(date: .numeric, time: .omitted))"])
                                }
                                
                                if let titulo = gratidao.titulo, let descricao = gratidao.descricao, let imagem = gratidao.imagem {
                                    ShareSheet(activityItems: ["\(titulo)\n\n\(descricao)\n\nEssa é minha gratidão por imagem no Gratify!"])
                                    if let UIImagem = UIImage(data:imagem){
                                        ShareSheet(activityItems: [UIImagem])
                                    }
                                }
                            }
                    } else {
                        Spacer()
                        Text("Adicione sua primeira gratidão! 😉")
                            .font(.footnote)
                            .foregroundColor(Color(.systemGray2))
                        Spacer()
                    }
                    
                    BarraDeAcoesView()
                    
                }
            }
            
        }
    }
}

struct SecaoListaView : View {
    @State var tipo:tipoSecao
    @Binding var filtrado:Bool
    @Binding var grupoAberto:Bool
    @Binding var pesquisa:String
    @State var compartilharAberto:Bool = false
    @Binding var elementoCompartilhado:Gratidao?
    @FetchRequest(sortDescriptors: [SortDescriptor(\.data, order: .reverse)]) var gratidoes:FetchedResults<Gratidao>

    var body: some View {
        Section (tipo.rawValue) {
                ForEach(gratidoes) { gratidao in
                    
                    if let tituloGratidao = gratidao.titulo {
                        if (filtrado == false || gratidao.favoritado == true)  && (tituloGratidao.localizedCaseInsensitiveContains(pesquisa) || pesquisa == ""){
                            if tipo == .diarioGratidao && gratidao.data != nil {
                                NavigationLink{
                                    DetalhamentoView(gratidao: gratidao)
                                } label: {
                                    ElementoLista(elementoCompartilhado: $elementoCompartilhado, gratidao: gratidao)
                                }
                            }
                        
                            if tipo == .gratidaoPorImagem && gratidao.data == nil{
                                NavigationLink{
                                    DetalhamentoView(gratidao: gratidao)
                                } label: {
                                    ElementoLista(elementoCompartilhado: $elementoCompartilhado, gratidao: gratidao)
                                }
                            }
                        }
                    }

                }
        }
    }
}


