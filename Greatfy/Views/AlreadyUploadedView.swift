//
//  AlreadyUploadedView.swift
//  Gratify
//
//  Created by Caio Marques on 11/06/24.
//

import SwiftUI

struct AlreadyUploadedView: View {
    @AppStorage ("alreadyUploaded") var alreadyUploaded = false
    @State var knowMore : Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("Seus dados foram migrados!")
                .bold()
                .font(.title2)
            Text("Reinicie o app para usar o Gratify!")
            
            Spacer()
            
            if knowMore {
                Text("Migramos o banco de dados antigo para um novo, nós usamos esse novo banco de dados para o widget do app poder ter acesso às alterações nos dados em tempo real, o aplicativo deve ser reiniciado para finalizar a migração corretamento, somente aperte no botão 'reiniciar' e abra o app novamente. Agradecemos a compreensão!")
                    .foregroundStyle(.primary)
                    .padding()
                    .background(Color(.pinky).opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
            }
            
            
            HStack {
                Text("Saber mais")
                Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(knowMore ? -90 : 0))
            }
            .bold()
            .foregroundStyle(.secondary)
            .onTapGesture {
                withAnimation {
                    knowMore.toggle()
                }
            }
            
            
            
            Button {
                alreadyUploaded = true
                exit(EXIT_SUCCESS)
            } label: {
                Text("Reiniciar")
                    .foregroundStyle(.background)
                    .font(.title3)
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .padding()
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
        }
        .padding(.horizontal)
        
    }
}

#Preview {
    AlreadyUploadedView()
}
