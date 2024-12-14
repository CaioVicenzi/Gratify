import SwiftUI

struct RegistrarTituloView: View {
    @StateObject var vm : RegisterViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            if vm.mostrarPopup {
                PopupErro(mostrarPopup: $vm.mostrarPopup)
            }
            Text("Dê um título curto para sua gratidão")
                .font(.headline)
            Text("Letras: \(vm.titulo.count)/\(vm.limitLetters)")
                .font(.callout)
                .foregroundStyle(.secondary)
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.background)
                .opacity(0.8)
                .overlay {
                    TextField("Título", text: $vm.titulo)
                        .foregroundStyle(.primary)
                        .padding()
                        .onChange(of: vm.titulo) { oldValue, newValue in
                            vm.onChangeTitle(oldValue, newValue)
                        }
                }
                .frame(height: 50)
            Spacer()
            Spacer()
        }
    }
}
