import SwiftUI

/// Onboarding
struct OnboardingView: View {
    @AppStorage("alreadyEnteredTheApp") var alreadyEnteredTheApp = false
    @State var goToNextScreen: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("Bem-vindo(a)!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            let columns = [GridItem(.fixed(100), alignment: .trailing), GridItem(.flexible(), alignment: .leading)]
            LazyVGrid(columns: columns) {
                onboardingElement(
                    "Escreva inputs de gratidão",
                    description: "Quando você se sentir grato por algum motivo, use o seu Gratify para registrar um motivo pelo qual você é grato!",
                    systemImage: "square.and.pencil")
                .padding(.vertical)
                
                
                onboardingElement(
                    "Pegue uma gratidão aleatória",
                    description: "Pegue uma gratidão aleatória para você se sentir melhor em um dia que você não sente que tem motivos para ser grato!",
                    systemImage: "dice")
                .padding(.vertical)
                
                
                onboardingElement(
                    "Aumente a sua streak com o tempo!",
                    description: "Com a funcionalidade de streaks é possível contar a quantos dias você tem sido grato!",
                    systemImage: "flame")
            }
            
            Spacer()
            Spacer()
            
            Button {
                alreadyEnteredTheApp = true
                goToNextScreen = true
            } label: {
                Text("Próxima")
                    .bold()
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    .foregroundColor(Color.white)
                    
            }
            
        }
        .fullScreenCover(isPresented: $goToNextScreen) {
            NavigationStack {
                HomeView()
            }
        }
    }
    
    @ViewBuilder
    func onboardingElement(_ title : String, description : String, systemImage : String) -> some View {
        
        Group {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 40)
                .bold()
                .foregroundStyle(Color.orange.secondary)
            
            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.semibold)
                Text(description)
                    .font(.caption)
            }
        }
        .padding(.trailing)
    }
}

#Preview {
    OnboardingView()
}
