//
//  PopupErro.swift
//  Gratify
//
//  Created by Caio Marques on 18/02/24.
//

import SwiftUI

struct PopupErro: View {
    @Binding var showPopup : Bool
    let limitLetters = 30
    
    var body: some View {
        Text("Limite de letras para o título é \(limitLetters) 😔")
            .foregroundStyle(.white)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .padding()
            .background(
                Color(red: 241 / 255, green: 56 / 255, blue: 56 / 255).opacity(0.8)
            )
            .cornerRadius(20)
            .padding(.horizontal)
            .overlay(alignment: .topLeading) {
                Button{
                    withAnimation {
                        showPopup = false
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

