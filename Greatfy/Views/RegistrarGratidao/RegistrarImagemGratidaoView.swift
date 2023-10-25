//
//  RegistrarImagemGratidaoView.swift
//  Greatfy
//
//  Created by Caio Marques on 14/05/23.
//

import SwiftUI

struct RegistrarImagemGratidaoView: View {

    
    
    @Binding var titulo:String
    @Binding var descricao:String
    var limite = 40
    @Binding var imagemData:Data?
    
    @State private var imagePicker = false
    @State private var camera = false
    @State private var actionSheetAparecendo = false
    
    var body: some View {
        VStack{
            Form{
                Text("Selecione uma foto do seu cotidiano que você goste").fontWeight(.bold)
                Button {
                    
                }
            label: {
                HStack{
                        Button {
                            actionSheetAparecendo = true
                        } label: {
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 10).frame(width: 144, height: 50).foregroundColor(Color(uiColor: .systemPurple))
                                HStack{
                                    Image(systemName: "camera")
                                    Text("imagem").fontWeight(.semibold
                                    )
                                    
                                }.foregroundColor(.white)
                            }
                            
                        }.actionSheet(isPresented: $actionSheetAparecendo) {
                            ActionSheet(title: Text("Selecione uma imagem"), message: Text("Como você quer selecionar ela?"), buttons: [
                                .default(Text("Galeria").foregroundColor(.purple)){
                                    imagePicker = true
                                },
                                .default(Text("Câmera")){
                                    camera = true
                                },
                                .cancel(Text("Cancelar"))
                            ])
                        }.sheet(isPresented: $camera) {
                            CameraView(isShown: $camera, dataImage: $imagemData)
                        }.sheet(isPresented: $imagePicker) {
                            ImagePicker(isImagePickerPresented: $imagePicker, imagemData: $imagemData)
                        }
                        Spacer()
                    
                    if let imagemData = imagemData {
                        if let imagemData = UIImage(data: imagemData)  {
                            Image(uiImage: imagemData)
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 50)
                                    .cornerRadius(8)
                            Button {
                                self.imagemData = nil
                            } label: {
                                Image(systemName: "xmark.circle")
                                
                            }

                        }
                    }
                    
                } // fim do HStack
                

            }
                Text("Dê um título para sua gratidão: ").fontWeight(.bold)
                TextField("Visão da...", text: $titulo).onChange(of: titulo) { novoValor in
                    if novoValor.count > limite {
                        titulo = String(novoValor.prefix(limite))
                    }
                }
                Text("Por que você é grato por isso? (escreva com o máximo de detalhes possível)").fontWeight(.bold)

                ZStack(alignment: .topLeading) {
                    if descricao.isEmpty {
                        Text("Eu sou grato pela...")
                            .foregroundColor(Color(UIColor.lightGray))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 12)
                    }
                    
                    TextEditor(text: $descricao)
                        .frame(maxHeight: .infinity)
                        .cornerRadius(8)
                }
            }
                Spacer()
        }.accentColor(Color(UIColor.systemPurple))
        }
    }



/*
struct RegistrarImagemGratidaoView_Previews: PreviewProvider {
    @State static var titulo:String = ""
    @State static var descricao:String = ""
    @State static var imagem:Optional<Image> = nil
    @State static var uiImage:Optional<UIImage> = nil
    static var previews: some View {
        RegistrarImagemGratidaoView(titulo: $titulo, descricao: $descricao, uiImagem: $uiImage)
    }
}
*/
