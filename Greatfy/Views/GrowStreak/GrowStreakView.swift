import SwiftUI

struct GrowStreakView: View {
    @Environment(\.managedObjectContext) var moc
    @StateObject var vm = GrowStreakViewModel()

    var body: some View {
        VStack (spacing: 40) {
            Spacer()
            thumbsUpHand
            
            VStack{
                if vm.animateLabel {
                    let streak = vm.calculateStreak(moc)
                    Text("Parabéns, você completou \(streak) dia\(streak > 1 ? "s" : "") de streak")
                    Text("Continue assim!")
                }
            }
            .font(.headline)
            
            Spacer()
            if vm.animateButton {
                Button {
                    vm.buttonPressed()
                } label: {
                    Text("Vamos nessa!")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color(.brightBlue))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                .navigationDestination(isPresented: $vm.goHomeView) {
                    HomeView()
                        .navigationBarBackButtonHidden()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RadialGradient(
                gradient:
                    Gradient(colors: [Color.accentColor.opacity(0.1), Color.orange]),
                center: .center,
                startRadius: 500,
                endRadius: 250
            )
        )
        .onAppear(perform: {
            vm.viewDidAppear(moc)
        })
    }
    
    var thumbsUpHand : some View {
        Image(systemName: "hand.thumbsup.fill")
            .resizable()
            .scaledToFit()
            .frame(width: vm.animateHand ? UIScreen.main.bounds.width / 3 : UIScreen.main.bounds.width / 5)
            .foregroundStyle(Color.white)
    }
}
