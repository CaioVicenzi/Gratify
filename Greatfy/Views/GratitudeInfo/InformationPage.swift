import SwiftUI

struct InformationPage: View {
    var body: some View {
        TabView {
            GratitudeInfo()
                .tag(1)
            
            InformationShortcutsView()
                .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}

#Preview {
    InformationPage()
}
