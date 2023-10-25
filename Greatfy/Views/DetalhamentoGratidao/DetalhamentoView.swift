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
    
    @State var edicao:Bool = false
    @State var tituloTemporario:String = ""
    @State var descricaoTemporaria:String = ""
    @State var compartilhamentoApresentado:Bool = false
    @State var camposVazios:Bool = false
    
    @FocusState var modoEdicao:Bool
    
    
    @Environment (\.presentationMode) var presentationMode: Binding <PresentationMode>

    // pegando a cor do ambiente
    @Environment(\.colorScheme) var colorScheme
 
    var body: some View {
            VStack{
                ScrollView{
                    VStack{
                        Text("")
                            .navigationBarBackButtonHidden(true)
                            .navigationBarItems(leading: BotaoVoltar()).toolbar{
                                if gratidao.descricao != descricaoTemporaria || gratidao.titulo != tituloTemporario {
                                    ToolbarItem (placement: .automatic){
                                        Button{
                                            if tituloTemporario == "" || descricaoTemporaria == "" {
                                                camposVazios = true
                                            } else {
                                                GratidaoController().editarGratidao(gratidao: gratidao, titulo: tituloTemporario, descricao: descricaoTemporaria, context: moc)
                                                modoEdicao = false
                                            }
                                        } label: {
                                            Text("Feito").fontWeight(.bold).foregroundColor(Color(.systemPurple))
                                        }.alert(isPresented: $camposVazios) {
                                            Alert(title: Text("Um dos campos não pode estar vazio..."))
                                        }
                                    }
                                } else {
                                    ToolbarItem (placement:.automatic) {
                                        Button {
                                            GratidaoController().mudarFavoritado(gratidao: gratidao, context: moc)
                                        } label: {
                                            Image(systemName: gratidao.favoritado ? "heart.fill" : "heart")
                                        }
                                    }
                                
                                    ToolbarItem (placement: .automatic) {
                                        Button {
                                            compartilhamentoApresentado = true
                                        } label: {
                                            Image(systemName: "square.and.arrow.up")
                                        }.sheet(isPresented: $compartilhamentoApresentado) {
                                            if let dataCerteza = gratidao.data {
                                                let texto:String = "\(gratidao.titulo!)\n\n\(gratidao.descricao!)\n\nEstou fazendo um diário da gratidão no Gratify! Esse foi do dia \(dataCerteza.formatted(date: .numeric, time: .omitted))"
                                                ShareSheet(activityItems: [texto])
                                            }
                                            if let imagemCerteza = gratidao.imagem {
                                                let texto:String = "\(gratidao.titulo!)\n\n\(gratidao.descricao!)\n\nEssa é minha gratidão por imagem no Gratify!"
                                                ShareSheet(activityItems: [texto])
                                                ShareSheet(activityItems: [imagemCerteza])
                                            }
                                        }

                                    }
                                }
                            }
                        HStack{
                            let limite:Int = 40
                            TextField("", text: $tituloTemporario).onChange(of: tituloTemporario) { novoValor in
                                if novoValor.count > limite {
                                    tituloTemporario = String(novoValor.prefix(limite))
                                }
                            }.focused($modoEdicao)
                                .font(.title3).fontWeight(.regular)
                            
                            Spacer()
                        }.padding().padding(.bottom, 20)
                        
                        Divider()
                        
                        HStack{
                            Text("Descrição")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.leading)
                            
                            Spacer()
                            if let dataCerteza = gratidao.data {
                                Text("\(formatarDataParaBrasileira(date: dataCerteza))")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.leading)
                            }
                            
                            
                        }.padding([.top, .trailing]).foregroundColor(colorScheme == .dark ?  corSecundaria: Color(UIColor.systemPurple))
                        
                        HStack{
                            
                            TextEditor(text: $descricaoTemporaria)
                                .frame(maxHeight: .infinity)
                                .cornerRadius(8)
                                .foregroundColor(.gray)
                                .padding([.top, .leading])
                                .fontWeight(.light)
                                .focused($modoEdicao)
                            Spacer()
                        }.padding()
                        
                        
                        if let imagemCerteza = gratidao.imagem {
                            if let imagemCerteza = UIImage(data: imagemCerteza){
                                HStack{
                                    Image(uiImage: imagemCerteza)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .cornerRadius(10)
                                        .padding()
                                }
                            }
                         }
                    }
                    
                    
                    Spacer()
                }.accentColor(Color.purple).gesture(DragGesture().onChanged({ _ in
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                }) ).onAppear{
                    tituloTemporario = gratidao.titulo ?? "titulo"
                    descricaoTemporaria = gratidao.descricao ?? "descricao"
                }
        }
    }
}





