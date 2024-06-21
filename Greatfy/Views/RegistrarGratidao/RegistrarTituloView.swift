//
//  RegistrarTituloView.swift
//  Gratify
//
//  Created by Caio Marques on 16/06/24.
//

import SwiftUI

struct RegistrarTituloView: View {
    @StateObject var vm : RegisterViewModel
    let limitLetters = 30
    
    var body: some View {
        VStack (alignment: .leading){
            Spacer()
            
            if vm.mostrarPopup {
                PopupErro(mostrarPopup: $vm.mostrarPopup)
            }
            Text("Dê um título curto para sua gratidão")
                .font(.headline)
            Text("Letras: \(vm.titulo.count)/\(limitLetters)")
                .font(.callout)
                .foregroundStyle(.secondary)
            RoundedRectangle (cornerRadius: 10)
                .foregroundStyle(.background)
                .opacity(0.8)
                .overlay {
                    TextField("Título", text: $vm.titulo)
                        .foregroundStyle(.primary)
                        .padding()
                        .onChange(of: vm.titulo) { oldValue, newValue in
                            if newValue.count > limitLetters {
                                withAnimation {
                                    vm.mostrarPopup = true

                                }
                                vm.titulo = oldValue
                            }
                        }
                }
                .frame(height: 50)
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    return VStack {
        RegistrarTituloView(vm : RegisterViewModel())
        HStack {
            Spacer()
            Button {
            } label: {
                HStack {
                    Image(systemName: "checkmark")
                    Text("Finalizar")
                }
                .foregroundStyle(.white)
                .padding()
                .padding(.horizontal)
                .background(Color(.brightBlue))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.top, 30)
    }
        .padding()
        .background(
            Image("fundoDiario")
                .resizable()
                .scaledToFill()
                .frame(height: .infinity)
                .ignoresSafeArea()
                .opacity(0.4)
        )}
