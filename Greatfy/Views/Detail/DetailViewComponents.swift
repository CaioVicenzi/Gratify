import Foundation
import SwiftUI

extension DetailView {
    var title : some View {
        HStack{
            TextField("Título da gratidão", text: $vm.temporaryTitle)
                .onChange(of: vm.temporaryTitle, {
                    vm.onChangeTitle()
                })
                .focused($editMode)
            .font(.title2)
            .fontWeight(.semibold)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    var shownDate : some View {
        VStack{
            if gratitude.data != nil {
                DatePicker("", selection: $vm.temporaryDate, in: .distantPast ... Date(), displayedComponents: .date)
            } else {
                Button {
                    gratitude.data = Date()
                } label: {
                    Text("Adicionar data")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.leading)
                }
            }
        }
    }
    
    var inclusionDateLabel : some View {
        VStack{
            if let incluseDate = gratitude.dataInclusao {
                Text("Gratidão adicionada no dia \(incluseDate.formatted(date: .numeric, time: .omitted) )")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(alignment: .leading)
            }
        }
    }
    
    var descriptionTextEditor : some View {
        TextEditor(text: $vm.temporaryDescription)
            .focused($editMode)
            .foregroundStyle(.gray)
            .padding(.horizontal)
    }
    
    var doneButton : some View {
        Button{
            vm.doneButtonPressed()
            editMode = false
        } label: {
            Text("Feito")
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
        }
        .alert(isPresented: $vm.showEmptyFieldsError) {
            Alert(title: Text("Um dos campos não pode estar vazio..."))
        }
    }
    
    var image : some View {
        VStack{
            if let image = gratitude.imagem, let uiImage = UIImage(data: image) {
                HStack{
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .padding()
                }
            } else if let temporaryImage = vm.temporaryImage, let uiImage = UIImage(data: temporaryImage) {
                HStack{
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .padding()
                }
            } else {
                addImageButton
            }
        }
             
    }
    
    var addImageButton : some View {
        Button {
            vm.addImage = true
        } label: {
            Text("Adicionar imagem")
        }.actionSheet(isPresented: $vm.addImage, content: {
            ActionSheet(title: Text("Selecione uma imagem"), message: Text("Como você quer selecionar ela?"), buttons: [
                .default(Text("Galeria").foregroundColor(.accentColor)){
                    vm.openImagePicker = true
                },
                .default(Text("Câmera")){
                    vm.openCamera = true
                },
                .cancel(Text("Cancelar"))
            ])
        }).sheet(isPresented: $vm.openCamera, content: {
            CameraView(isShown: $vm.openCamera, dataImage: $vm.temporaryImage)
        }).sheet(isPresented: $vm.openImagePicker, content: {
            ImagePicker(isImagePickerPresented: $vm.openImagePicker, imagemData: $vm.temporaryImage)
        })
    }
    
    var shareButton : some View {
        Button {
            vm.openShare = true
        } label: {
            Image(systemName: "square.and.arrow.up")
        }.sheet(isPresented: $vm.openShare) {
            vm.shareGratitude()
        }
    }
    
    var favButton : some View {
        Button {
            HapticHandler.instance.impact(feedbackStyle: .light)
            GratitudeController().toggleFavorited(gratitude: gratitude, context: moc)
        } label: {
            Image(systemName: gratitude.favoritado ? "heart.fill" : "heart")
        }
    }
}
