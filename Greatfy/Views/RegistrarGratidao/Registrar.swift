//
//  Registrar.swift
//  Greatfy
//
//  Created by Caio Marques on 03/05/23.
//

import SwiftUI

struct Registrar: View {
    @State var titulo:String = ""
    @State var descricao:String = ""
    
    @State var tituloParaImagem:String = ""
    @State var descricaoParaImagem:String = ""
    
    @State var data:Date = Date()
    @State var selecionado:String = "diario"
    @State var imagemData:Data? = nil
    @Environment (\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment (\.managedObjectContext) var moc
    
    var body: some View {
        VStack {
                VStack{
                    //ScrollView{
                        Text("")
                            .navigationBarBackButtonHidden(true)
                            .navigationBarItems(leading: BotaoVoltar()).toolbar{
                                
                                ToolbarItem (placement: .navigationBarTrailing) {
                                    BotaoSalvar(titulo: $titulo, descricao: $descricao, tituloParaImagem: $tituloParaImagem, descricaoParaImagem: $descricaoParaImagem, selecionado: $selecionado, imagemData: $imagemData)
                                }
                            }
                        
                        HStack{
                            Text("Gratidão")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                            Spacer()
                                
                            }.padding()
                                Picker("", selection: $selecionado) {
                                Image(systemName: "note.text").tag("diario")
                                Image(systemName: "photo").tag("imagem-gratidao")
                                }.pickerStyle(.segmented).background(colorScheme == .light ? corSecundaria : Color(uiColor: .darkGray))
                        .clipShape(RoundedRectangle(cornerRadius: 6)).padding()
                            Divider()
                            
                            
                        if(selecionado == "diario"){
                            RegistrarDiarioView(titulo: $titulo, descricao: $descricao)
                        } else {
                            RegistrarImagemGratidaoView(titulo: $tituloParaImagem, descricao: $descricaoParaImagem, imagemData: $imagemData)
                        }
                        Spacer()
                    }
                //}
                
                
            }.gesture(DragGesture().onChanged({ _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }) ).accentColor(Color.purple)
    }
}


struct BotaoSalvar : View {
    @Binding var titulo:String
    @Binding var descricao: String
    
    @Binding var tituloParaImagem:String
    @Binding var descricaoParaImagem:String
    
    @State var vazio:Bool = false
    @Binding var selecionado:String
    @Binding var imagemData:Data?
    @State var nenhumaImagemSelecionada: Bool = false
    @Environment (\.presentationMode) var presentationMode: Binding <PresentationMode>
    @Environment (\.managedObjectContext) var moc

    
    var body: some View {
        Button {
            if selecionado == "diario" {
                // se o titulo tiver coisa dentro, então salva
                if (!titulo.isEmpty && !descricao.isEmpty) {
                    GratidaoController().adicionarGratidaoDiario(titulo: titulo, descricao: descricao, context: moc)
                    
                    // voltar para a tela de início
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    vazio = true
                }
            }
            else {
                if (!tituloParaImagem.isEmpty && !descricaoParaImagem.isEmpty && imagemData != nil){
                    if let imagemData = imagemData {
                        GratidaoController().adicionarGratidaoPorImagem(titulo: tituloParaImagem, descricao: descricaoParaImagem, imageData: imagemData, context: moc)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    vazio = true
                }
                 
            }
             
        } label: {
            Text("Salvar").padding().foregroundColor(Color(UIColor.systemPurple))
        }.alert(isPresented: $vazio) {
            return Alert(title: Text("Faltou alguma coisa..."))
        }
    }
}

struct Registrar_Previews: PreviewProvider {
    static var previews: some View {
        Registrar()
    }
}
