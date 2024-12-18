import SwiftUI

struct RegisterDetailsView: View {
    @StateObject var vm : RegisterViewModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: 20){
            Spacer()
            DatePicker("Que dia foi isso?", selection: $vm.data, displayedComponents: .date)
                .font(.headline)
            
            Text("Adicionar uma imagem?")
                .font(.headline)
            
            Button {
                vm.showActionSheet.toggle()
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
        .actionSheet(isPresented: $vm.showActionSheet) {
            ActionSheet(title: Text("Selecione uma imagem"), message: Text("Como você quer selecionar ela?"), buttons: [
                .default(Text("Galeria").foregroundColor(.purple)){
                    vm.showImagePicker = true
                },
                .default(Text("Câmera")){
                    vm.showCamera = true
                },
                .cancel(Text("Cancelar"))
            ])
        }
        .sheet(isPresented: $vm.showCamera) {
            CameraView(isShown: $vm.showCamera, dataImage: $vm.imagemData)
        }.sheet(isPresented: $vm.showImagePicker) {
            ImagePicker(isImagePickerPresented: $vm.showImagePicker, imagemData: $vm.imagemData)
        }
    }
}
