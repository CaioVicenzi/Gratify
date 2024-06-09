//
//  DetalhamentoViewComponents.swift
//  Gratify
//
//  Created by Caio Marques on 08/06/24.
//

import Foundation
import SwiftUI

extension DetalhamentoView {
    var titulo : some View {
        HStack{
            TextField("Título da gratidão", text: $vm.tituloTemporario)
                .onChange(of: vm.tituloTemporario, {
                    vm.changeTitle()
                })
                .focused($modoEdicao)
            .font(.title2)
            .fontWeight(.semibold)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    var dataExibida : some View {
        VStack{
            if gratidao.data != nil {
                DatePicker("", selection: $vm.dataTemporaria, in: .distantPast ... Date(), displayedComponents: .date)
            } else {
                Button {
                    gratidao.data = Date()
                } label: {
                    Text("Adicionar data")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.leading)
                }
            }
        }
    }
    
    var dataInclusao : some View {
        VStack{
            if let dataInclusao = gratidao.dataInclusao {
                Text("Gratidão adicionada no dia \(dataInclusao.formatted(date: .numeric, time: .omitted) )")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(alignment: .leading)
            }
        }
    }
    
    var descricao : some View {
        TextEditor(text: $vm.descricaoTemporaria)
            .focused($modoEdicao)
            .foregroundStyle(.gray)
            .padding(.horizontal)
    }
    
    var botaoFeito : some View {
        Button{
            vm.doneButtonPressed()
            modoEdicao = false
        } label: {
            Text("Feito")
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
        }
        .alert(isPresented: $vm.camposVazios) {
            Alert(title: Text("Um dos campos não pode estar vazio..."))
        }
    }
    
    var imagem : some View {
        VStack{
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
            } else if let imagemTemporariaCerteza = vm.imagemTemporaria {
                HStack{
                    if let uiImagem = UIImage(data: imagemTemporariaCerteza) {
                        Image(uiImage: uiImagem)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                            .padding()
                    }
                }
            } else {
                botaoAdicionarImagem
            }
        }
    }
    
    var botaoAdicionarImagem : some View {
        Button {
            vm.adicionarImagem = true
        } label: {
            Text("Adicionar imagem")
        }.actionSheet(isPresented: $vm.adicionarImagem, content: {
            ActionSheet(title: Text("Selecione uma imagem"), message: Text("Como você quer selecionar ela?"), buttons: [
                .default(Text("Galeria").foregroundColor(.accentColor)){
                    vm.imagePicker = true
                },
                .default(Text("Câmera")){
                    vm.camera = true
                },
                .cancel(Text("Cancelar"))
            ])
        }).sheet(isPresented: $vm.camera, content: {
            CameraView(isShown: $vm.camera, dataImage: $vm.imagemTemporaria)
        }).sheet(isPresented: $vm.imagePicker, content: {
            ImagePicker(isImagePickerPresented: $vm.imagePicker, imagemData: $vm.imagemTemporaria)
        })
    }
    
    var shareButton : some View {
        Button {
            vm.compartilhamentoApresentado = true
        } label: {
            Image(systemName: "square.and.arrow.up")
        }.sheet(isPresented: $vm.compartilhamentoApresentado) {
            vm.shareGratitude()
        }
    }
    
    var favButton : some View {
        Button {
            HapticHandler.instance.impacto(estilo: .light)
            GratidaoController().mudarFavoritado(gratidao: gratidao, context: moc)
        } label: {
            Image(systemName: gratidao.favoritado ? "heart.fill" : "heart")
        }
    }
}
