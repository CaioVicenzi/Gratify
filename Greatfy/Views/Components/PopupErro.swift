//
//  PopupErro.swift
//  Gratify
//
//  Created by Caio Marques on 18/02/24.
//

import SwiftUI

struct PopupErro: View {
    @Binding var mostrarPopup : Bool
    
    var body: some View {
        Text("Limite de letras para o título é \(limiteTitulo) 😔")
            .foregroundStyle(.white)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .padding()
            .background(
                Color(red: 241 / 255, green: 56 / 255, blue: 56 / 255).opacity(0.9)
            )
            .cornerRadius(20)
            .padding(.horizontal)
            //.clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(alignment: .topLeading) {
                Button{
                    withAnimation {
                        mostrarPopup = false
                    }
                } label: {
                      Image(systemName: "xmark.circle")
                }
                .tint(.white)
                .padding(.horizontal, 25)
                .padding(.top, 10)
            }
    }
}

