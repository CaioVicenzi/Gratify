import SwiftUI
import WidgetKit

struct RegisterView : View {
    @StateObject var vm : RegisterViewModel = RegisterViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack {
            vm.fieldsToShow(vm.page)
            
            HStack {
                Button("Voltar") {
                    vm.goBackButtonPressed()
                }
                .disabled(vm.page == 0)
                
                Spacer()
                Button {
                    vm.nextButtonPressed()
                } label: {
                    HStack {
                        Image(systemName: vm.page >= 2 ? "checkmark" : "play.fill")
                        Text(vm.page >= 2 ? "Finalizar" : "Próximo")
                            .bold()
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(Color(.brightBlue))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .alert(Text("Preencha o campo corretamente..."), isPresented: $vm.showEmptyFieldError) {
                    Button ("OK") {}
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
            vm.configVM(moc: moc, dismiss: dismiss)
        })
        .navigationDestination(isPresented: $vm.goGrowStreak) {
            GrowStreakView()
                .navigationBarBackButtonHidden()
        }
    }
}

/*
#Preview {
    NavigationStack {
        RegistrarGratidaoView()
    }
}
*/
