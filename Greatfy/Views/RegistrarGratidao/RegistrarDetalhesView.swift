import SwiftUI

struct RegistrarDetalhesView: View {
    @StateObject var vm : RegisterViewModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: 20){
            Spacer()
            DatePicker("Que dia foi isso?", selection: $vm.data, displayedComponents: .date)
                .font(.headline)
            
            Text("Adicionar uma imagem?")
                .font(.headline)
            
            Button {
                vm.actionSheetAparecendo.toggle()
            } label: {
                HStack {
                    Image(systemName: "camera")
                    Text("Imagem")
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            if let imageData = vm.imagemData {
                HStack {
                    Spacer()
                    Button {
                        vm.excludeImageButtonPressed()
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                }
                
                Image(uiImage: UIImage(data: imageData)!)
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
        }
        .actionSheet(isPresented: $vm.actionSheetAparecendo) {
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
        .sheet(isPresented: $vm.camera) {
            CameraView(isShown: $vm.camera, dataImage: $vm.imagemData)
        }.sheet(isPresented: $vm.imagePicker) {
            ImagePicker(isImagePickerPresented: $vm.imagePicker, imagemData: $vm.imagemData)
        }
    }
}
