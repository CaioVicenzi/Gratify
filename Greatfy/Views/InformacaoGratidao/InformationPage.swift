//
//  InformationPage.swift
//  StreakWidgetExtension
//
//  Created by Caio Marques on 12/06/24.
//

import SwiftUI

struct InformationPage: View {
    var body: some View {
        TabView {
            InformacaoGratidao()
                .tag(1)
            
            InformationShortcutsView()
                .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .tabViewStyle(.page)
        
    }
}

#Preview {
    InformationPage()
}
