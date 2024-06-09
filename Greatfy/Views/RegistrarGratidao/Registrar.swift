//
//  Registrar.swift
//  Greatfy
//
//  Created by Caio Marques on 03/05/23.
//

import SwiftUI
import WidgetKit

struct RegistrarGratidaoView: View {
    @StateObject var vm = RegisterViewModel()
    
    @Environment (\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment (\.managedObjectContext) var moc
    
    var body: some View {
        VStack {
            //RegistrarDiarioView(titulo: $titulo, descricao: $descricao, data: $data, imagemData: $imagemData)
            VStack{
                if vm.mostrarPopup{
                    PopupErro(mostrarPopup: $vm.mostrarPopup)
                }
                
                Form () {
                    Section {
                        DatePicker(
                            "Data: ",
                            selection: $vm.data,
                            in: .distantPast ... Date(),
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.automatic)
                    }
                    Section {
                        ZStack (alignment: .topLeading, content: {
                            if vm.titulo.isEmpty {
                                Text("Insira um motivo pelo qual você é grato")
                                    .foregroundStyle(Color(.systemGray3))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 12)
                            }
                            TextEditor(text: $vm.titulo)
                                .foregroundColor(.gray)
                                .background(Color.clear)
                                .onChange(of: vm.titulo) { novoValor in
                                    vm.titleValueChanged(newValue: novoValor)
                                }
                        })
                        .font(.title3)
                        
                        
                        ZStack(alignment: .topLeading) {
                            if vm.descricao.isEmpty {
                                Text("Por que você é grato por isso? (descreva com o máximo de detalhes possível)")
                                    .foregroundColor(Color(.systemGray3))
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 12)
                            }
                            
                            TextEditor(text: $vm.descricao)
                                .frame(maxHeight: .infinity)
                                .cornerRadius(8)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 4)
                                .padding(.bottom, 12)
                                .padding(.top, 2)
                        }
                        
                        HStack{
                            Button {
                                vm.actionSheetAparecendo = true
                            } label: {
                                Spacer()
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10).frame(width: 144, height: 50).foregroundColor(.accentColor)
                                    HStack{
                                        Image(systemName: "camera")
                                        Text("imagem").fontWeight(.semibold)
                                    }.foregroundColor(.white)
                                }
                                Spacer()
                                
                            }.actionSheet(isPresented: $vm.actionSheetAparecendo) {
                                ActionSheet(title: Text("Selecione uma imagem"), message: Text("Como você quer selecionar ela?"), buttons: [
                                    .default(Text("Galeria").foregroundColor(.accentColor)){
                                        vm.imagePicker = true
                                    },
                                    .default(Text("Câmera")){
                                        vm.camera = true
                                    },
                                    .cancel(Text("Cancelar"))
                                ])
                            }.sheet(isPresented: $vm.camera) {
                                CameraView(isShown: $vm.camera, dataImage: $vm.imagemData)
                            }.sheet(isPresented: $vm.imagePicker) {
                                ImagePicker(isImagePickerPresented: $vm.imagePicker, imagemData: $vm.imagemData)
                            }
                            Spacer()
                        }
                        
                        if let dataImage = vm.imagemData {
                            if let imagemData = UIImage(data: dataImage) {
                                VStack {
                                    Button {
                                        vm.imagemData = nil
                                    } label: {
                                        Image(systemName: "xmark.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .frame(alignment: .trailing)
                                    }
                                    
                                    Image(uiImage: imagemData)
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(8)
                                }
                                
                            }
                        }
                    }
                }
                    
                
            }

            
            Spacer()
        }
        .navigationTitle("Nova gratidão")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem (placement: .navigationBarTrailing) {
                VStack{
                    Button {
                        vm.saveGratitude()
                    } label: {
                        Text("Salvar")
                            .padding()
                            .bold()
                            .foregroundColor(.accentColor)
                    }.alert(isPresented: $vm.vazio) {
                        vm.returnAlert()
                    }
                }
                .navigationDestination(isPresented: $vm.mostrarStreakAumentando) {
                    StreakAumentandoView()
                        .navigationBarBackButtonHidden()
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                BotaoVoltar()
            }
        })
        .onAppear(perform: {
            vm.configVM(moc: moc, dismiss: dismiss)
        })
    }
}

struct Registrar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegistrarGratidaoView()
        }
    }
}

/*
 .gesture(DragGesture().onChanged {
     UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
 }
 */
