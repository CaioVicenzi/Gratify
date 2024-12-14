import SwiftUI

struct RegistrarDescricaoView: View {
    @StateObject var vm : RegisterViewModel
    
    var body: some View {
        VStack  (alignment: .leading){
            // título
            Text("Pelo que você é grato?")
                .font(.headline)
                .padding(.bottom, 30)
            
            
            Notebook(text: $vm.descricao)
                .opacity(0.6)
        }
    }
}

