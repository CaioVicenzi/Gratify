//
//  Registrar.swift
//  Greatfy
//
//  Created by Caio Marques on 03/05/23.
//

import SwiftUI
import WidgetKit



struct RegistrarGratidaoView : View {
    @State var page : Int = 0
    @StateObject var vm : RegisterViewModel = RegisterViewModel()

    @Environment (\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment (\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Gratidao.data, ascending: false)]) var gratidoes:FetchedResults<Gratidao>
    
    var body: some View {
        VStack {
            Group {
                if page == 0 {
                    RegistrarDescricaoView(vm: vm)
                } else if page == 1 {
                    RegistrarDetalhesView(vm: vm)
                } else {
                    RegistrarTituloView(vm: vm)
                }
            }
            HStack {
                Button("Voltar") {
                    withAnimation {
                        page -= 1
                    }
                }
                .disabled(page == 0)
                
                Spacer()
                Button {
                    if page >= 2 {
                        vm.saveGratitude(fetchedResults: gratidoes)
                        dismiss()
                    } else {
                        withAnimation {
                            if page == 0 {
                                if !vm.descricao.isEmpty {
                                    page += 1
                                } else {
                                    vm.vazio = true
                                }
                            } else if page == 1 {
                                page += 1
                            } else {
                                if !vm.titulo.isEmpty {
                                    vm.vazio = true
                                } else {
                                    page += 1
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        if page >= 2 {
                            Image(systemName: "checkmark")
                            Text("Finalizar")
                        } else {
                            Image(systemName: "play.fill")
                            Text("Próximo")
                        }
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(Color(.brightBlue))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .alert(Text("Preencha o campo corretamente..."), isPresented: $vm.vazio) {
                    Button ("OK") {
                        
                    }
                }
            }
            .padding(.top, 30)
            
        }
        .padding()
        .background(
            Image("fundoDiario")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
                .opacity(0.4)
        )
        .onAppear(perform: {
            vm.configVM(moc: moc, dismiss: dismiss, fetchedResults: gratidoes)
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
struct RegistrarGratidaoView: View {
    @StateObject var vm : RegisterViewModel = RegisterViewModel()
    
    @Environment (\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment (\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Gratidao.data, ascending: false)]) var gratidoes:FetchedResults<Gratidao>

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
                                .onChange(of: vm.titulo, { _, novoValor in
                                    vm.titleValueChanged(newValue: novoValor)
                                })
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
                                    RoundedRectangle(cornerRadius: 10).frame(width: 144, height: 50).foregroundColor(.purple)
                                    HStack{
                                        Image(systemName: "camera")
                                        Text("imagem").fontWeight(.semibold)
                                    }.foregroundColor(.white)
                                }
                                Spacer()
                                
                            }.actionSheet(isPresented: $vm.actionSheetAparecendo) {
                                ActionSheet(title: Text("Selecione uma imagem"), message: Text("Como você quer selecionar ela?"), buttons: [
                                    .default(Text("Galeria").foregroundColor(.purple)){
                                        vm.imagePicker = true
                                    },
                                    .default(Text("Câmera")){
                                        vm.camera = true
                                    },
                                    .cancel(Text("Cancelar"))
                                ])
                            }
                            Spacer()
                        }
                        
                        if let dataImage = vm.imagemData {
                            if let imagemData = UIImage(data: dataImage) {
                                VStack {
                                    
                                    HStack {
                                        Button {
                                            withAnimation (.spring){
                                                vm.imagemData = nil
                                            }
                                        } label: {
                                            Image(systemName: "xmark.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20)
                                        }
                                        Spacer()
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
                        vm.saveGratitude(fetchedResults: gratidoes)
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
            vm.configVM(moc: moc, dismiss: dismiss, fetchedResults: gratidoes)
        })
    }
}



/*
 .gesture(DragGesture().onChanged {
     UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
 }
 */
*/






